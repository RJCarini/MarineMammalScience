% Add path to data.
addpath 'LitReviewSurveyProject/'

% Import data into a table.
opts = detectImportOptions('LitReviewData_FINAL.xlsx');
% preview('LitReviewData_FINAL.xlsx',opts)
T = readtable('LitReviewData_FINAL.xlsx',opts);
% whos T

% Contenate and preprocess documents.
documents = [T.Title,T.Abstract,T.Keywords];
documents = strcat(documents(:,1),{' '},documents(:,2),{' '},documents(:,3));
documents = preprocessTextData(documents);

% % Create a bag-of-words model from the tokenized data.
% bag = bagOfWords(documents);
% 
% % Remove words that do not appear more than twice, and remove bags
% % containing no words.
% bag = removeInfrequentWords(bag,2);
% bag = removeEmptyDocuments(bag);
% 
% figure
% wordcloud(bag);

%% Find searchwords in documents...
% Searchwords = conservation, policy, management, endangered, threatened
tbl_cons = context(documents,"conservation");
tbl_mgmt = context(documents,"management");
tbl_prot = context(documents,"protection");
tbl_endg = context(documents,"endangered");

% remove cases of "conservation of fluids" and "protection from wind/waves/etc"
badcons = [2,3,8,9,10,11,27,36,37,38,136];
badprot = [8,11,16,17,18,19,20,24,27,28,29,39];
tbl_cons(badcons,:) = [];
tbl_prot(badprot,:) = [];

unq_cons = unique(tbl_cons.Document);
unq_mgmt = unique(tbl_mgmt.Document);
unq_prot = unique(tbl_prot.Document);
unq_endg = unique(tbl_endg.Document);
year_cons = T.Year(unq_cons);
year_mgmt = T.Year(unq_mgmt);
year_prot = T.Year(unq_prot);
year_endg = T.Year(unq_endg);

%% general search word occurrence (before removing double counting)
edges = 1984.5:1:2019.5;
centers = 1985:1:2019;
[n_Year] = histcounts(T.Year,edges);
[n_cons] = histcounts(year_cons,edges);
[n_mgmt] = histcounts(year_mgmt,edges);
[n_prot] = histcounts(year_prot,edges);
[n_endg] = histcounts(year_endg,edges);

%%
figure('position',[0 0 1280 704])
cmap = [240,249,232;186,228,188;123,204,196;67,162,202;8,104,172]./255;
b1 = bar(centers,n_Year);
set(b1,'FaceColor',[.5 .5 .5])
hold on
h = bar(centers',n_cons(:));
set(h(1),'FaceColor',cmap(4,:))
grid on
legend('No Search Words','"Conservation"','location','NorthWest')
title('Histogram of Search Word Occurrence')
xlabel('Year')
ylabel('Number of Articles')
ylim([0 70])
xlim([1984 2020])
set(gca,'FontSize',20,'YMinorGrid','on')

% pathim = '/Users/rjcarini/Desktop/LitReviewSurveyProject/figures/';    
% set(gcf,'PaperPositionMode','auto')
% print([pathim,'Histogram_Cons'],'-dpng','-r0')

%%
figure('position',[0 0 1280 704])
cmap = [240,249,232;186,228,188;123,204,196;67,162,202;8,104,172]./255;
b1 = bar(centers,n_Year);
set(b1,'FaceColor',[.5 .5 .5])
hold on
h = bar(centers',n_mgmt(:));
set(h(1),'FaceColor',cmap(3,:))
grid on
legend('No Search Words','"Management"','location','NorthWest')
title('Histogram of Search Word Occurrence')
xlabel('Year')
ylabel('Number of Articles')
ylim([0 70])
xlim([1984 2020])
set(gca,'FontSize',20,'YMinorGrid','on')

% pathim = '/Users/rjcarini/Desktop/LitReviewProject/figures/';    
% set(gcf,'PaperPositionMode','auto')
% print([pathim,'Histogram_Mgmt'],'-dpng','-r0')

%%
figure('position',[0 0 1280 704])
cmap = [240,249,232;186,228,188;123,204,196;67,162,202;8,104,172]./255;
b1 = bar(centers,n_Year);
set(b1,'FaceColor',[.5 .5 .5])
hold on
h = bar(centers',n_endg(:));
set(h(1),'FaceColor',cmap(2,:))
grid on
legend('No Search Words','"Endangered"','location','NorthWest')
title('Histogram of Search Word Occurrence')
xlabel('Year')
ylabel('Number of Articles')
ylim([0 70])
xlim([1984 2020])
set(gca,'FontSize',20,'YMinorGrid','on')

% pathim = '/Users/rjcarini/Desktop/LitReviewProject/figures/';    
% set(gcf,'PaperPositionMode','auto')
% print([pathim,'Histogram_Endg'],'-dpng','-r0')

%%
figure('position',[0 0 1280 704])
cmap = [240,249,232;186,228,188;123,204,196;67,162,202;8,104,172]./255;
b1 = bar(centers,n_Year);
set(b1,'FaceColor',[.5 .5 .5])
hold on
h = bar(centers',n_prot(:));
set(h(1),'FaceColor',cmap(1,:))
grid on
legend('No Search Words','"Protection"','location','NorthWest')
title('Histogram of Search Word Occurrence')
xlabel('Year')
ylabel('Number of Articles')
ylim([0 70])
xlim([1984 2020])
set(gca,'FontSize',20,'YMinorGrid','on')

% pathim = '/Users/rjcarini/Desktop/LitReviewProject/figures/';    
% set(gcf,'PaperPositionMode','auto')
% print([pathim,'Histogram_Prot'],'-dpng','-r0')

%%
few_consmgmtprot = mintersect(unq_cons,unq_mgmt,unq_prot);
few_consmgmtendg = mintersect(unq_cons,unq_mgmt,unq_endg);
few_consprotendg = mintersect(unq_cons,unq_endg,unq_prot);
few_mgmtprotendg = mintersect(unq_endg,unq_mgmt,unq_prot);
few = unique([few_consmgmtprot;few_consmgmtendg;few_consprotendg;few_mgmtprotendg]);

both_consmgmt = intersect(unq_cons,unq_mgmt);
both_consprot = intersect(unq_cons,unq_prot);
both_consendg = intersect(unq_cons,unq_endg);
both_mgmtprot = intersect(unq_mgmt,unq_prot);
both_mgmtendg = intersect(unq_mgmt,unq_endg);
both_endgprot = intersect(unq_endg,unq_prot);
both = unique([both_consmgmt;both_consprot;both_consendg;both_mgmtprot;both_mgmtendg;both_endgprot]);

combo = unique([few;both]);
year_combo = T.Year(combo);
jj = 1; kk = 1; ll = 1; mm = 1;
for i = 1:length(combo)
    temp = find(unq_cons==combo(i));
    if ~isempty(temp)
        bad_cons(jj) = temp;
        jj = jj+1;
    end
    temp = find(unq_mgmt==combo(i));
    if ~isempty(temp)
        bad_mgmt(kk) = temp;
        kk = kk+1;
    end
    temp = find(unq_prot==combo(i));
    if ~isempty(temp)
        bad_prot(ll) = temp;
        ll = ll+1;
    end
    temp = find(unq_endg==combo(i));
    if ~isempty(temp)
        bad_endg(mm) = temp;
        mm = mm+1;
    end
end
unq_cons(bad_cons) = [];
year_cons = T.Year(unq_cons);
unq_mgmt(bad_mgmt) = [];
year_mgmt = T.Year(unq_mgmt);
unq_prot(bad_prot) = [];
year_prot = T.Year(unq_prot);
unq_endg(bad_endg) = [];
year_endg = T.Year(unq_endg);

% Stacked histograms
edges = 1984.5:1:2019.5;
centers = 1985:1:2019;
[n_Year] = histcounts(T.Year,edges);
[n_cons] = histcounts(year_cons,edges);
[n_mgmt] = histcounts(year_mgmt,edges);
[n_prot] = histcounts(year_prot,edges);
[n_endg] = histcounts(year_endg,edges);
[n_combo] = histcounts(year_combo,edges);

%% Compute percentage of total articles
n_SW = n_cons(:)+n_mgmt(:)+n_prot(:)+n_endg(:)+n_combo(:);
rate_SW = n_SW./n_Year(:);

fit1 = fit(centers',rate_SW,'poly1');
fdata = feval(fit1,centers');
I = abs(fdata-rate_SW) > 1.5*std(rate_SW);
outliers = excludedata(centers',rate_SW,'indices',I);
fit2 = fit(centers',rate_SW,'poly1','Exclude',outliers);


%%
figure('position',[0 0 1280 704])
yyaxis left
cmap = [240,249,232;186,228,188;123,204,196;67,162,202;8,104,172]./255;
b1 = bar(centers,n_Year);
set(b1,'FaceColor',[.7 .7 .7],'EdgeColor','w')
hold on
h = bar(centers',[n_combo(:) n_cons(:) n_mgmt(:) n_endg(:) n_prot(:)],'Stacked');
set(h(1),'FaceColor',cmap(5,:),'EdgeColor','w')
set(h(2),'FaceColor',cmap(4,:),'EdgeColor','w')
set(h(3),'FaceColor',cmap(3,:),'EdgeColor','w')
set(h(4),'FaceColor',cmap(2,:),'EdgeColor','w')
set(h(5),'FaceColor',cmap(1,:),'EdgeColor','w')
grid on
legend('No Search Words','Any Combination of Search Words','"Conservation", n=54','"Management", n=54','"Endangered", n=28','"Protection", n=10','location','NorthWest')
xlabel('Year')
ylabel('Number of Articles')
ylim([0 70])
xlim([1984 2020])
set(gca,'FontSize',20,'YMinorGrid','on','YColor',[.3 .3 .3])

yyaxis right
p1 = plot(fit1,'--k',centers',rate_SW,'k.',outliers,'*k');
p1(1).DisplayName = 'data';
p1(2).DisplayName = 'outliers';
p1(3).DisplayName = 'fitted curve (outliers included)';
set(p1(1),'MarkerSize',25)
set(p1(2),'MarkerSize',15,'LineWidth',1.5)
set(p1(3),'LineWidth',2)
hold on
p2 = plot(fit2,'-k');
p2.DisplayName = 'fitted curve (outliers excluded)';
set(p2,'LineWidth',2);
set(legend,'location','NorthWest')
grid on
xlabel('Year')
ylabel('Percent of Articles')
ylim([0 0.5])
xlim([1984 2020])
text(2016,0.21,'slope = 0.56','Color','k')
text(2016,0.255,'slope = 0.63','Color','k')
set(gca,'FontSize',20,'YTick',[0:0.05:0.5],'YTickLabels',0:5:50,'YColor','k')

% pathim = '/Users/rjcarini/Desktop/LitReviewSurveyProject/figures/';    
% set(gcf,'PaperPositionMode','auto')
% print([pathim,'LitReviewPlot'],'-dpng','-r0')
