#include <stdio.h>
#include <string.h>

char bits(char);

int main(int argc, char *argv[])
{
	int len, i, j;
	char random_str[] = {0xD6, 0xA6, 0x9E, 0x86, 0x42, 0xFA, 0x2E, 0xF6, 0x76, 
						 0xFA, 0xA6, 0x4E, 0x86, 0xFA, 0xAE, 0xF6, 0x9E};

	if (argc < 2)
	{
		printf ("\nUsage: %s <password>\n", argv[0]);
		return 0;
	}

	len = strlen(argv[1]);

	for (int i = 0; i < len; i++)
	{
		argv[1][i] = bits(argv[1][i]);
	}

	for (i = 0, j = (len - 1); i < j; i++, j--)
	{
		argv[1][i] ^= argv[1][j];
		argv[1][j] ^= argv[1][i];
		argv[1][i] ^= argv[1][j];
	}

	printf("\nThis is your flag: %s\n", argv[1]);

	return 0;
}

char bits(char ch)
{
	char i, sum;

	sum = 0;

	for (i = 0; i < 4; i++)
	{
		sum = sum | ( ((1 << (2 * i) & ch) << 1) | ((2 << (2 * i) & ch) >> 1) );
	}

	ch = sum;
	sum = 0;

	for (i = 0; i < 2; i++)
	{
		sum = sum | ( ((3 << (4 * i) & ch) << 2 ) | ((12 << (4 * i) & ch) >> 2) );
	}

	ch = sum;
	sum = 0;

	sum = sum | ( ((15 & ch) << 4) | (240 & ch) >> 4 );

	return sum;
}