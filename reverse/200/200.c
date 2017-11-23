#include <stdio.h>
#include <stdlib.h>

void filling_mas(FILE *, char *);

int main()
{
	FILE *image = NULL;
	char file_name[255];
	char flag[14];
	char operating_bytes[11] = {65, 2, 24, 0, 0, 0, 0, 0, 0, 0, 0};
	char byte;
	int i, j;

	printf("Hello! Give me file for translation: ");
	scanf("%s", file_name);
	image = fopen(file_name, "rb");
	
	if (image == NULL)
	{
		printf("\nCannot open file!\n");
		system("pause");
		return 0;
	}
	
	filling_mas(image, flag);
	fclose(image);
	printf("\nTranslated text: ");
	
	for (i = 0; i < 11; i++)
	{
		flag[13] = flag[13] ^ operating_bytes[i];
		byte = flag[13] & flag[i];
		putchar(byte);
	}

	printf("\n\n");
	system("pause");

	return 0;
}

void filling_mas(FILE *image, char *flag)
{
	fseek(image, 0xAB70, SEEK_SET);
	char byte, bit;
	int i, j;

	for (i = 0; i < 12; i++)
	{
		flag[i] = 0;
	}

	for (i = 0; i < 8; i++)
	{
		for (j = 0; j < 12; j++)
		{
			bit = 1;
			fread(&byte, sizeof(char), 1, image);
			bit &= byte;
			bit <<= i;
			flag[j] += bit;
		}
	}
}
