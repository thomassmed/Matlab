%@(#)   print_water.m 1.2	 08/04/23     08:01:30
%
%function f = print_water(axstr, eocfil, fp3, radnum, g, id, knr)


function f = print_water(axstr, eocfil, fp3, radnum, g, id, knr)

cpos = axis2cpos(axstr);
[asyid, mminj] = readdist7(eocfil, 'asyid');

if rem(cpos(1),2) ~= 0 & rem(cpos(2),2) ~= 0
  cpos1(1) = cpos(1) - 2;
  cpos1(2) = cpos(2) - 2;
  cpos2(1) = cpos(1) - 2;
  cpos2(2) = cpos(2) - 1;
  cpos3(1) = cpos(1) - 2;
  cpos3(2) = cpos(2);
  cpos4(1) = cpos(1) - 2;
  cpos4(2) = cpos(2) + 1;
  cpos5(1) = cpos(1) - 2;
  cpos5(2) = cpos(2) + 2;
  cpos6(1) = cpos(1) - 2;
  cpos6(2) = cpos(2) + 3;
  
  cpos7(1) = cpos(1) - 1;
  cpos7(2) = cpos(2) - 2;
  cpos8(1) = cpos(1) - 1;
  cpos8(2) = cpos(2) - 1;
  cpos10(1) = cpos(1) - 1;
  cpos10(2) = cpos(2);
  cpos11(1) = cpos(1) - 1;
  cpos11(2) = cpos(2) + 1;
  cpos12(1) = cpos(1) - 1;
  cpos12(2) = cpos(2) + 2;
  cpos13(1) = cpos(1) - 1;
  cpos13(2) = cpos(2) + 3;

  cpos14(1) = cpos(1);
  cpos14(2) = cpos(2) - 2;
  cpos15(1) = cpos(1);
  cpos15(2) = cpos(2) - 1;
  cpos16(1) = cpos(1);
  cpos16(2) = cpos(2);
  cpos17(1) = cpos(1);
  cpos17(2) = cpos(2) + 1;
  cpos18(1) = cpos(1);
  cpos18(2) = cpos(2) + 2;
  cpos19(1) = cpos(1);
  cpos19(2) = cpos(2) + 3;

  cpos20(1) = cpos(1) + 1;
  cpos20(2) = cpos(2) - 2;
  cpos21(1) = cpos(1) + 1;
  cpos21(2) = cpos(2) - 1;
  cpos22(1) = cpos(1) + 1;
  cpos22(2) = cpos(2);
  cpos23(1) = cpos(1) + 1;
  cpos23(2) = cpos(2) + 1;
  cpos24(1) = cpos(1) + 1;
  cpos24(2) = cpos(2) + 2;
  cpos25(1) = cpos(1) + 1;
  cpos25(2) = cpos(2) + 3;
  
  cpos26(1) = cpos(1) + 2;
  cpos26(2) = cpos(2) - 2;
  cpos27(1) = cpos(1) + 2;
  cpos27(2) = cpos(2) - 1;
  cpos28(1) = cpos(1) + 2;
  cpos28(2) = cpos(2);
  cpos29(1) = cpos(1) + 2;
  cpos29(2) = cpos(2) + 1;
  cpos30(1) = cpos(1) + 2;
  cpos30(2) = cpos(2) + 2;
  cpos31(1) = cpos(1) + 2;
  cpos31(2) = cpos(2) + 3;
  
  cpos32(1) = cpos(1) + 3;
  cpos32(2) = cpos(2) - 2;
  cpos33(1) = cpos(1) + 3;
  cpos33(2) = cpos(2) - 1;
  cpos34(1) = cpos(1) + 3;
  cpos34(2) = cpos(2);
  cpos35(1) = cpos(1) + 3;
  cpos35(2) = cpos(2) + 1;
  cpos36(1) = cpos(1) + 3;
  cpos36(2) = cpos(2) + 2;
  cpos37(1) = cpos(1) + 3;
  cpos37(2) = cpos(2) + 3;
  
  num = 15;
  
elseif rem(cpos(1),2) ~= 0 & rem(cpos(2),2) == 0
  cpos1(1) = cpos(1) - 2;
  cpos1(2) = cpos(2) - 3;
  cpos2(1) = cpos(1) - 2;
  cpos2(2) = cpos(2) - 2;
  cpos3(1) = cpos(1) - 2;
  cpos3(2) = cpos(2) - 1;
  cpos4(1) = cpos(1) - 2;
  cpos4(2) = cpos(2);
  cpos5(1) = cpos(1) - 2;
  cpos5(2) = cpos(2) + 1;
  cpos6(1) = cpos(1) - 2;
  cpos6(2) = cpos(2) + 2;

  cpos7(1) = cpos(1) - 1;
  cpos7(2) = cpos(2) - 3;
  cpos8(1) = cpos(1) - 1;
  cpos8(2) = cpos(2) - 2;
  cpos10(1) = cpos(1) - 1;
  cpos10(2) = cpos(2) - 1;
  cpos11(1) = cpos(1) - 1;
  cpos11(2) = cpos(2);
  cpos12(1) = cpos(1) - 1;
  cpos12(2) = cpos(2) + 1;
  cpos13(1) = cpos(1) - 1;
  cpos13(2) = cpos(2) + 2;
    
  cpos14(1) = cpos(1);
  cpos14(2) = cpos(2) - 3;
  cpos15(1) = cpos(1);
  cpos15(2) = cpos(2) - 2;
  cpos16(1) = cpos(1);
  cpos16(2) = cpos(2) - 1;
  cpos17(1) = cpos(1);
  cpos17(2) = cpos(2);
  cpos18(1) = cpos(1);
  cpos18(2) = cpos(2) + 1;
  cpos19(1) = cpos(1);
  cpos19(2) = cpos(2) + 2; 
    
  cpos20(1) = cpos(1) + 1;
  cpos20(2) = cpos(2) - 3;
  cpos21(1) = cpos(1) + 1;
  cpos21(2) = cpos(2) - 2;
  cpos22(1) = cpos(1) + 1;
  cpos22(2) = cpos(2) - 1;
  cpos23(1) = cpos(1) + 1;
  cpos23(2) = cpos(2);
  cpos24(1) = cpos(1) + 1;
  cpos24(2) = cpos(2) + 1;
  cpos25(1) = cpos(1) + 1;
  cpos25(2) = cpos(2) + 2;  
    
  cpos26(1) = cpos(1) + 2;
  cpos26(2) = cpos(2) - 3;
  cpos27(1) = cpos(1) + 2;
  cpos27(2) = cpos(2) - 2;
  cpos28(1) = cpos(1) + 2;
  cpos28(2) = cpos(2) - 1;
  cpos29(1) = cpos(1) + 2;
  cpos29(2) = cpos(2);
  cpos30(1) = cpos(1) + 2;
  cpos30(2) = cpos(2) + 1;
  cpos31(1) = cpos(1) + 2;
  cpos31(2) = cpos(2) + 2; 
    
  cpos32(1) = cpos(1) + 3;
  cpos32(2) = cpos(2) - 3;
  cpos33(1) = cpos(1) + 3;
  cpos33(2) = cpos(2) - 2;
  cpos34(1) = cpos(1) + 3;
  cpos34(2) = cpos(2) - 1;
  cpos35(1) = cpos(1) + 3;
  cpos35(2) = cpos(2);
  cpos36(1) = cpos(1) + 3;
  cpos36(2) = cpos(2) + 1;
  cpos37(1) = cpos(1) + 3;
  cpos37(2) = cpos(2) + 2;
  
  num = 16; 
      
elseif rem(cpos(1),2) == 0 & rem(cpos(2),2) ~= 0
  cpos1(1) = cpos(1) - 3;
  cpos1(2) = cpos(2) - 2;
  cpos2(1) = cpos(1) - 3;
  cpos2(2) = cpos(2) - 1;
  cpos3(1) = cpos(1) - 3;
  cpos3(2) = cpos(2);
  cpos4(1) = cpos(1) - 3;
  cpos4(2) = cpos(2) + 1;
  cpos5(1) = cpos(1) - 3;
  cpos5(2) = cpos(2) + 2;
  cpos6(1) = cpos(1) - 3;
  cpos6(2) = cpos(2) + 3;
  
  cpos7(1) = cpos(1) - 2;
  cpos7(2) = cpos(2) - 2;
  cpos8(1) = cpos(1) - 2;
  cpos8(2) = cpos(2) - 1;
  cpos10(1) = cpos(1) - 2;
  cpos10(2) = cpos(2);
  cpos11(1) = cpos(1) - 2;
  cpos11(2) = cpos(2) + 1;
  cpos12(1) = cpos(1) - 2;
  cpos12(2) = cpos(2) + 2;
  cpos13(1) = cpos(1) - 2;
  cpos13(2) = cpos(2) + 3;
  
  cpos14(1) = cpos(1) - 1;
  cpos14(2) = cpos(2) - 2;
  cpos15(1) = cpos(1) - 1;
  cpos15(2) = cpos(2) - 1;
  cpos16(1) = cpos(1) - 1;
  cpos16(2) = cpos(2);
  cpos17(1) = cpos(1) - 1;
  cpos17(2) = cpos(2) + 1;
  cpos18(1) = cpos(1) - 1;
  cpos18(2) = cpos(2) + 2;
  cpos19(1) = cpos(1) - 1;
  cpos19(2) = cpos(2) + 3;
  
  cpos20(1) = cpos(1);
  cpos20(2) = cpos(2) - 2;
  cpos21(1) = cpos(1);
  cpos21(2) = cpos(2) - 1;
  cpos22(1) = cpos(1);
  cpos22(2) = cpos(2);
  cpos23(1) = cpos(1);
  cpos23(2) = cpos(2) + 1;
  cpos24(1) = cpos(1);
  cpos24(2) = cpos(2) + 2;
  cpos25(1) = cpos(1);
  cpos25(2) = cpos(2) + 3;
  
  cpos26(1) = cpos(1) + 1;
  cpos26(2) = cpos(2) - 2;
  cpos27(1) = cpos(1) + 1;
  cpos27(2) = cpos(2) - 1;
  cpos28(1) = cpos(1) + 1;
  cpos28(2) = cpos(2);
  cpos29(1) = cpos(1) + 1;
  cpos29(2) = cpos(2) + 1;
  cpos30(1) = cpos(1) + 1;
  cpos30(2) = cpos(2) + 2;
  cpos31(1) = cpos(1) + 1;
  cpos31(2) = cpos(2) + 3;
  
  cpos32(1) = cpos(1) + 2;
  cpos32(2) = cpos(2) - 2;
  cpos33(1) = cpos(1) + 2;
  cpos33(2) = cpos(2) - 1;
  cpos34(1) = cpos(1) + 2;
  cpos34(2) = cpos(2);
  cpos35(1) = cpos(1) + 2;
  cpos35(2) = cpos(2) + 1;
  cpos36(1) = cpos(1) + 2;
  cpos36(2) = cpos(2) + 2;
  cpos37(1) = cpos(1) + 2;
  cpos37(2) = cpos(2) + 3;
  
  num = 21;
  
elseif rem(cpos(1),2) == 0 & rem(cpos(2),2) == 0
  cpos1(1) = cpos(1) - 3;
  cpos1(2) = cpos(2) - 3;
  cpos2(1) = cpos(1) - 3;
  cpos2(2) = cpos(2) - 2;
  cpos3(1) = cpos(1) - 3;
  cpos3(2) = cpos(2) - 1;
  cpos4(1) = cpos(1) - 3;
  cpos4(2) = cpos(2);
  cpos5(1) = cpos(1) - 3;
  cpos5(2) = cpos(2) + 1;
  cpos6(1) = cpos(1) - 3;
  cpos6(2) = cpos(2) + 2;
  
  cpos7(1) = cpos(1) - 2;
  cpos7(2) = cpos(2) - 3;
  cpos8(1) = cpos(1) - 2;
  cpos8(2) = cpos(2) - 2;
  cpos10(1) = cpos(1) - 2;
  cpos10(2) = cpos(2) - 1;
  cpos11(1) = cpos(1) - 2;
  cpos11(2) = cpos(2);
  cpos12(1) = cpos(1) - 2;
  cpos12(2) = cpos(2) + 1;
  cpos13(1) = cpos(1) - 2;
  cpos13(2) = cpos(2) + 2;
  
  cpos14(1) = cpos(1) - 1;
  cpos14(2) = cpos(2) - 3;
  cpos15(1) = cpos(1) - 1;
  cpos15(2) = cpos(2) - 2;
  cpos16(1) = cpos(1) - 1;
  cpos16(2) = cpos(2) - 1;
  cpos17(1) = cpos(1) - 1;
  cpos17(2) = cpos(2);
  cpos18(1) = cpos(1) - 1;
  cpos18(2) = cpos(2) + 1;
  cpos19(1) = cpos(1) - 1;
  cpos19(2) = cpos(2) + 2; 
  
  cpos20(1) = cpos(1);
  cpos20(2) = cpos(2) - 3;
  cpos21(1) = cpos(1);
  cpos21(2) = cpos(2) - 2;
  cpos22(1) = cpos(1);
  cpos22(2) = cpos(2) - 1;
  cpos23(1) = cpos(1);
  cpos23(2) = cpos(2);
  cpos24(1) = cpos(1);
  cpos24(2) = cpos(2) + 1;
  cpos25(1) = cpos(1);
  cpos25(2) = cpos(2) + 2;  
  
  cpos26(1) = cpos(1) + 1;
  cpos26(2) = cpos(2) - 3;
  cpos27(1) = cpos(1) + 1;
  cpos27(2) = cpos(2) - 2;
  cpos28(1) = cpos(1) + 1;
  cpos28(2) = cpos(2) - 1;
  cpos29(1) = cpos(1) + 1;
  cpos29(2) = cpos(2);
  cpos30(1) = cpos(1) + 1;
  cpos30(2) = cpos(2) + 1;
  cpos31(1) = cpos(1) + 1;
  cpos31(2) = cpos(2) + 2; 
  
  cpos32(1) = cpos(1) + 2;
  cpos32(2) = cpos(2) - 3;
  cpos33(1) = cpos(1) + 2;
  cpos33(2) = cpos(2) - 2;
  cpos34(1) = cpos(1) + 2;
  cpos34(2) = cpos(2) - 1;
  cpos35(1) = cpos(1) + 2;
  cpos35(2) = cpos(2);
  cpos36(1) = cpos(1) + 2;
  cpos36(2) = cpos(2) + 1;
  cpos37(1) = cpos(1) + 2;
  cpos37(2) = cpos(2) + 2;
  
  num = 22;
  
end

knum(1,1) = cpos2knum(cpos1, mminj);
knum(1,2) = cpos2knum(cpos2, mminj);
knum(1,3) = cpos2knum(cpos3, mminj);
knum(1,4) = cpos2knum(cpos4, mminj);
knum(1,5) = cpos2knum(cpos5, mminj);
knum(1,6) = cpos2knum(cpos6, mminj);
knum(2,1) = cpos2knum(cpos7, mminj);
knum(2,2) = cpos2knum(cpos8, mminj);
knum(2,3) = cpos2knum(cpos10, mminj);
knum(2,4) = cpos2knum(cpos11, mminj);
knum(2,5) = cpos2knum(cpos12, mminj);
knum(2,6) = cpos2knum(cpos13, mminj);
knum(3,1) = cpos2knum(cpos14, mminj);
knum(3,2) = cpos2knum(cpos15, mminj);
knum(3,3) = cpos2knum(cpos16, mminj); %15
knum(3,4) = cpos2knum(cpos17, mminj); %16
knum(3,5) = cpos2knum(cpos18, mminj);
knum(3,6) = cpos2knum(cpos19, mminj);
knum(4,1) = cpos2knum(cpos20, mminj);
knum(4,2) = cpos2knum(cpos21, mminj);
knum(4,3) = cpos2knum(cpos22, mminj); %21
knum(4,4) = cpos2knum(cpos23, mminj); %22
knum(4,5) = cpos2knum(cpos24, mminj);
knum(4,6) = cpos2knum(cpos25, mminj);
knum(5,1) = cpos2knum(cpos26, mminj);
knum(5,2) = cpos2knum(cpos27, mminj);
knum(5,3) = cpos2knum(cpos28, mminj);
knum(5,4) = cpos2knum(cpos29, mminj);
knum(5,5) = cpos2knum(cpos30, mminj);
knum(5,6) = cpos2knum(cpos31, mminj);
knum(6,1) = cpos2knum(cpos32, mminj);
knum(6,2) = cpos2knum(cpos33, mminj);
knum(6,3) = cpos2knum(cpos34, mminj);
knum(6,4) = cpos2knum(cpos35, mminj);
knum(6,5) = cpos2knum(cpos36, mminj);
knum(6,6) = cpos2knum(cpos37, mminj);



fprintf(fp3, '\n\n____________________________________________________________________');
fprintf(fp3, '\n');
fprintf(fp3, '\nRows in shufflefile:\t%.0i', radnum);
fprintf(fp3, '\nBundle Case number:\t%.0i', g);
fprintf(fp3, '\nBundle Identity:\t%s', id);
fprintf(fp3, '\nMoved to position:\t%.0i', knr);
fprintf(fp3, '\n');



for i = 1:6
  fprintf(fp3, '\n');
  for j = 1:6
    if knum(i,j) == 0
      fprintf(fp3, '       ');
    
    elseif knum(i,j) == knr
      fprintf(fp3, ' bundle');
    
    elseif strcmp(asyid(knum(i,j), 1:3), 'vat') == 1
      fprintf(fp3, ' vatten');
     
    else
      fprintf(fp3, ' ------');
    end
  end
end
    
    
      
    









