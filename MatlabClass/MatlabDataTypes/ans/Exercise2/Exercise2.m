%% Exercise 2 - Big Mac Nutritional Data

%% 2.1 Import data
load Exercise2.mat;

%% 2.2a Aggregate variables to create a 1-by-8 cell array
% c1 is a 1-by-8 cell array, each cell of which contains a 27-by-1 entity
c1 = {country,energy,carbohydrates,protein,fat,fiber,sodium,serving_size};

%% 2.2b Aggregate variables to create a 27-by-8 cell array
% c2 is a 27-by-8 cell array, each cell of which contains a scalar entity
c2 = [country, num2cell(energy), num2cell(carbohydrates), num2cell(protein), ...
      num2cell(fat), num2cell(fiber), num2cell(sodium), num2cell(serving_size)];

%% 2.3a Aggregate variables to create a 1-by-1 structure array
% s1 is a 1-by-1 structure with eight fields that each contains a 27-by-1 entity
s1.country = country;
s1.energy = energy;
s1.carbohydrates = carbohydrates;
s1.protein = protein;
s1.fat = fat;
s1.fiber = fiber;
s1.sodium = sodium;
s1.servingsize = serving_size;

%% 2.3b Aggregate variables to create a 27-by-1 structure array
% s2 is a 27-by-1 structure; each record contains eight fields with a single entity
s2 = struct('country', country, 'energy', num2cell(energy), 'carbohydrates', ...
            num2cell(carbohydrates), 'protein', num2cell(protein), 'fat', ...
            num2cell(fat), 'fiber', num2cell(fiber), 'sodium', num2cell(sodium), ...
            'servingsize', num2cell(serving_size));

%% 2.4 Modify units of sodium in c1, s1
% Convert sodium values from milligrams to grams
c1{7} = c1{7} / 1000;
s1.sodium = s1.sodium / 1000;

%% 2.5 Use c1, c2, s1, s2 to answer questions

% Which country's burger has the most fat?
c1{1}(c1{5} == max(c1{5}))
c2([c2{:,5}] == max([c2{:,5}]))
s1.country(s1.fat == max(s1.fat))
s2([s2.fat] == max([s2.fat])).country

% Which country's burger has the least sodium?
c1{1}(c1{7} == min(c1{7}))
c2([c2{:,7}] == min([c2{:,7}]))
s1.country(s1.sodium == min(s1.sodium))
s2([s2.sodium] == min([s2.sodium])).country