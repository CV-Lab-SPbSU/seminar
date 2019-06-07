K=ZZ/30097
R=K[x,y,z,MonomialOrder=>GRevLex]
X11 = random 30097
...
W33 = random 30097
f1 = ...
...
f10 = ...
I=ideal(f1|f2|f3|f4|f5|f6|f7|f8|f9|f10)
dim I
gbTrace=3
gens gb I
A = R/I
basis A
leadTerm I

