#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void first(int *);
int second(int, int);
int third(int);
void protect();

int main ()
{
	int arr[4];
	int i, j = 2, t;

	for (i = 0; i < 4; i++)
	{
		t = i*j;
		j++;
		arr[i] = t;
	}

	first(arr);

	return 0;
}

void first(int *arr)
{
	int a, b;
	int i;
	int c[3];

	a = 2;
	b = a ^ 27;
	for (i = 0; i < 3; i++)
	{
		c[i] = (second(a, b) + arr[i]) - third(c[i]);
	}

	return;
}

int second(int a, int b)
{
	int d;

	d = (a+b) & (a-b);
	if (d < 10)
	{
		return 300;
	}
	else
	{
		return d;
	}
}

int third(int num)
{
	int a = 11, b = 0;

	for (; a > 8; a--)
	{
		b += a - num;
	}

	if (a < 11)
	{
		protect();
	}
	
	return b;
}

void protect()
{
	int i;
	char a = 0x72;
	char b[] = {0x26, 0x1A, 0x1B, 0x1,  0x52, 0x1B, 0x1,  0x52, 0x13, 0x52,
				0x14, 0x13, 0x19, 0x17, 0x52, 0x17, 0xA,  0x17, 0x11, 0x7,
				0x6,  0x13, 0x10, 0x1E, 0x17, 0x52, 0x14, 0x1B, 0x1E, 0x17, 0x0};
	
	for (i = 0; i < strlen(b); i++)
	{
		putchar(a ^ b[i]);
	}

	exit(0);
}
