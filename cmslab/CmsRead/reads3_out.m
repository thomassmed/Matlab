function [dist, is_3d, mminj, num_cases, distlist, CycExp, konrod] = reads3_out(outfile, distname, case_no, mminj,crmax)
% [dist, is_3d, mminj, num_cases, konrod, distlist] = reads3_out(outfile,distname, case_no, mminj)
%
% Input:
% outfile        - name of out file containing the SIM cases
% distname       - desired distribution type Note: for example, you can
% send in a pattern (assuming 3D distributions), like:
% fi2=reads3_out('mydir/s3-1.out','PRI.STA 3FLX  -  ASSEMBLY 3D FLX - Group 2');
%
% case_no        - case number for which to fetch data
% mminj          - Core contour, default read from restart_file, supplying
%                  mminj gives better performance
%
% Output:
% dist           - num_axial_points x num_bundles matrix containing distribution values
% is_3d          - boolean indicating 2-d or 3-d output distribution
% mminj          - 1 x n array of bundle starting position in each core row
% num_cases      - number of cases in outfile
% konrod         - number of axial points at which TIP measurements are taken
% distlist       - list of possible distributions to fetch from this file
%
% Example:
%  >> DEN3=reads3_out('s3.out','3DEN');
%  >> power_3D=reads3_out('s3-output-file.out','3rpf');
%  >> fi2=reads3_out('/cms/files/s3-1.out','PRI.STA 3FLX  -  ASSEMBLY 3D FLX - Group 2');
%
% See also read_restart_bin, read_pri_mac, reads3_tip, reads3_tip_CASENO,
% reads3_tip_calc, reads3_tip_calc_CASENO, reads3_tip_map,
% reads3_tip_meas, reads3_tip_meas_CASENO 
% 
if nargin<2, distname=[];end

if nargin<3, case_no=[]; end
% TODO fix CR and to read in all dists from a file including 3D and page problems

% read the OUTPUT file

[blob, cr, num_cases, iCase,CycExp] = reads3_file(outfile, case_no);
if length(case_no)==1,
    reduced_blob=1;
else
    reduced_blob=0;
end


if nargout>6, 
    if exist('crmax','var'),
        konrod=read_crdpos_out(blob,crmax);
    else
        konrod=read_crd_pos(blob);
    end
end

[kmax,iafull]=out2param(blob);

if nargin<4, 
    sumfile=strrep(outfile,'.out','.sum');
    if exist(sumfile,'file'),
        core=AnalyzeSum(sumfile);
        mminj=core.mminj;
    else
        mminj=out2mminj(blob,iafull); 
    end
end



% distribution name reader
distname_length = length(distname);             % find length of string
if distname_length<31,
    distname = remblank(distname);                  % remove any blanks
    distname_length = length(distname);             % find length of string
    distname=upper(distname);
    if strcmp(distname(1), '3')
        is_3d=1;
    else
        is_3d=0;
    end
end

if length(distname)==3, distname=[distname,' '];end % For 3BV etc

if distname_length>30,
      string_to_find = distname;                      % search for calculated
      adapt_flag = 0;
      iE = strfind(blob, string_to_find);             % string positions of string we found
      if ~exist('is_3d','var'),
         is_3d=1;
      end
elseif distname_length>1,
  if strcmp(distname(distname_length - 1 : distname_length), '-A'),
      string_to_find = ['A-PRI.STA ', distname(1 : distname_length - 2), '  -'];   % search for adapted
      adapt_flag = 1;
      iE = strfind(blob, string_to_find);             % string positions of string we found
  else
      string_to_find = [' PRI.STA ', distname,'  -']; % search for calculated
      string_to_find =char([10,string_to_find]);
      adapt_flag = 0;
      iE = strfind(blob, string_to_find);             % string positions of string we found
      if numel(iE)==0, 
          string_to_find(2)=[];
          iE = strfind(blob, string_to_find);   
      end % Remove first space if newre version
      iE = strfind(blob, string_to_find);   
  end
else
  distname='0';
end

if ~exist('is_3d','var')
    is_3d=0;
end

if is_3d==1,
    distname='3XXX';
else
    distname='2XXX';
end

if isempty(case_no)
     case_no=1:num_cases;
else
    if reduced_blob,
        case_no=1;
    end
end
i_page=1;
for icase=case_no,
    if is_3d,
    % 3D distribution read
        kan=sum(iafull-2*(mminj-1));
        A=zeros(kmax,kan);
        % loop over a SIM "page" and read the 2 row block values
        % left half first
        f_o_p=1;i_add=2;
        page_str='S I M U L A T E - 3';
        icr = find(cr > iE(i_page), 1 );                   % find carriage return after the position we're searching
        line = blob(cr(icr) + 1 : cr(icr + 1) - 1);        % find row number to be read
        islash=strfind(line,'/');
        irow=sscanf(line(islash-2:islash-1),'%i');
        line=blob(cr(icr+1)+1:cr(icr+2)-1);                    % find columns to be read
        islash=strfind(line,'/');
        jcol=zeros(length(islash),1);
        for ii=1:length(islash),
            jcol(ii)=sscanf(line(islash(ii)-2:islash(ii)-1),'%i');
        end
        irow=irow*ones(size(jcol));
        chnum=cpos2knum(irow,jcol,mminj);
        i_zero=find(chnum==0);chnum(i_zero)=[];
        if iafull>20, mult=2;else mult=1;end
        for i = 1 : mult*iafull                        % divided by two because there are two sets of row values on a page
            for node = 1 : kmax                    % loop over the axial nodes in the first row of values on page
                j = icr + node + i_add;             % find nodal value row (the 2 skips the 2 header columns)
                line = blob(cr(j) + 4 : cr(j + 1) - 1); % read the line
                A(kmax + 1 - node, chnum) = sscanf(line, '%g'); % build the matrix of values with node 1 on top, 25 on bottom
            end
            line = blob(cr(j+1)+1:cr(j+2)-1);           % Check for page break
            ibreak=0;
            if isempty(line)||~isempty(strfind(line,page_str)),     % Page break
                i_page=i_page+1;
                if i_page>length(iE),
                    ibreak=1;break;
                else
                    icr = find(cr > iE(i_page), 1 );
                    line = blob(cr(icr) + 1 : cr(icr + 1) - 1);         % find row number to be read
                    islash=strfind(line,'/');
                    irow=sscanf(line(islash-2:islash-1),'%i');
                    line=blob(cr(icr+1)+1:cr(icr+2)-1);                 % find columns to be read
                    islash=strfind(line,'/');
                    jcol=zeros(length(islash),1);
                    for ii=1:length(islash),
                        jcol(ii)=sscanf(line(islash(ii)-2:islash(ii)-1),'%i');
                    end
                    irow=irow*ones(size(jcol));
                    chnum=cpos2knum(irow,jcol,mminj);
                    i_zero=find(chnum==0);chnum(i_zero)=[];
                    i_add=2;
                end
            else                                                    % No Page break
                islash=strfind(line,'/');
                irow=sscanf(line(islash-2:islash-1),'%i');
                irow=irow*ones(size(jcol));                         % Find row to be read
                chnum=cpos2knum(irow,jcol,mminj);
                i_zero=find(chnum==0);chnum(i_zero)=[];
                i_add=kmax+3;
            end
            if ibreak, break; end
        end
    else    
    % 2D distribution read
        % Left half first
        if length(iE)>length(case_no),
            iEcase=2*icase-1;
        else
            iEcase=icase;
        end
        icr = min(find(cr > iE(iEcase)));                % find carriage return after the position we're searching
        for i = 1 : iafull                           % loop over the iafull rows
            chnum = knumhalf_row(mminj, i);         % find the channel numbers of this block of values
            j = icr + i;                            % find beginning of next row
            line = blob(cr(j) + 4 : cr(j + 1) - 5); % read the line
            A(1, chnum) = sscanf(line, '%g');       % build the vector of values
        end
        % Right half next
        j=j+2;
        for i=1:20,
            line=blob(cr(j) + 1 : cr(j + 1) - 1);
            if length(line)>3,
                if strfind(line(1:4),'**'), icr=j;break;end
            end
            j=j+1;
        end
        %{
    if (adapt_flag == 1) % adapted values don't have second header..doh!
        icr = j + 3;                            % find carriage return after the position we're searching
    else
        icr = min(find(cr > iE(2)));            % find carriage return after the position we're searching
    end
        %}
        for i = 1 : iafull                           % loop over the iafull rows
            chnum = knumhalf_row(mminj, i);         % find the channel numbers of this block of values
            j = icr + i;                            % find beginning of next row
            line = blob(cr(j) + 4 : cr(j + 1) - 5); % read the line
            B(1, chnum) = sscanf(line, '%g');       % build the vector of values
        end
    end
    
    % put the distribution matrices together
    if strcmp(distname(1),'0'),
        dist=[];
    elseif is_3d
        dist=A;
    else
        [right, left] = knumhalf(mminj);                % create vectors that contain channel numbers for each column in A and B
        ll = length(left);                              % determine number of channels in each A and B
        left = left(ll : -1 : 1);                       % this flips the numbers of the left column
        dist(:, left) = A;                              % synthesize channel numbers to nodal values
        dist(:, right) = B;                             % synthesize channel numbers to nodal values
    end
    if length(case_no)>1,
        Dist{icase}=dist;
    end
end
%% Get a list of all distributions
if nargout > 4
    distlist=out2distlist(blob);
end
if length(case_no)>1,
    dist=Dist;
end