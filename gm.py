from scipy.stats.mstats import gmean

ls = list()
f = open("times.txt","r")
f1 = f.readlines()

for x in f1:
    ls.append(float(x.strip()))
    
print(gmean(ls))
