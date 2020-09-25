.PHONY: all

ALL : e1_cf_c.exe e1_cf_f.exe

e1_cf_c.exe: e1_cf.c
	gcc -o e1_cf_c.exe e1_cf.c -O3 -lm -s

e1_cf_f.exe: e1_cf.f90
	gfortran -o e1_cf_f.exe e1_cf.f90

clean:
	rm e1_cf_c.exe e1_cf_f.exe

