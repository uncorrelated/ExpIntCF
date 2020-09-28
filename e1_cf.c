#include<stdlib.h>
#include<stdio.h>
#include<math.h>
#include<complex.h>
#include<time.h>

double _Complex _E1_cf(double _Complex z, int n){
	double _Complex cf = z;
	for(int i=n;1<=i;i--){
		cf = z + (1 + i) / cf;
		cf = 1 + i / cf;
	}
	return cexp(-z) / (z + 1/cf);
}

double _Complex E1_cf(double _Complex z, double reltol){
	for(int n=1; n <= 1000; n++){
		double _Complex s = _E1_cf(z, n);
		double _Complex d = _E1_cf(z, 2*n);
		if(cabs(s - d) < reltol*cabs(d)){
			return d;
		}
	}
	fprintf(stderr, "iteration limit exceeded!");
	exit(-1);
}

double _Complex *MakeMatrix(double s, double e, int length){
	double _Complex *m = calloc(length * length, sizeof(double _Complex));
	for(int j=0; j<length; j++){
		double x = s + (e - s)/(length - 1)*j;
		for(int i=0; i<length; i++){
			double y = s + (e - s)/(length - 1)*i;
			m[length*j + i] = E1_cf(x + y * _Complex_I, 1e-12);	
		} 
	} 
	return m;
}

FILE *fileopen(const char *fname){
	FILE *stream;
	if(NULL==(stream=fopen(fname, "w"))){
		fprintf(stderr, "Couldn't open the file: %s\n", fname);
		exit(-2);
	}
	return stream;
}

int main(){
	long	et;
	int		length = 100;

// make a matrix, and save it.
	et = clock();
	double _Complex *m = MakeMatrix(0.1, 5, length); 
	printf("elapsed time: %f seconds\n", (double)(clock() - et)/CLOCKS_PER_SEC);

// save the matrix.
	FILE *stream = fileopen("e1_cf.c.txt");
	for(int j=0; j<length; j++){
		for(int i=0; i<length; i++){
			fprintf(stream, "%.6f+%.6fim\t", creal(m[length*j + i]), cimag(m[length*j + i]));
		}
		fprintf(stream, "\n");
	} 
	fclose(stream);

	return 0;	
}
