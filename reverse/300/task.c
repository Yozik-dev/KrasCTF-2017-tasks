#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void protect();
void fail(FILE *);

int main(int argc, char *argv)
{
	char name_of_file[256];
	FILE *key = NULL;
	char deductions[] = {0xC, 0x10, 0x1, 0x30,
		      	     	 0xA, 0x30, 0x0, 0x30,
		             	 0xD, 0x20, 0x6, 0x20,
		             	 0xE, 0x30, 0x9, 0x20};

	char message[] = {0x4A, 0x55, 0x53, 0x54,
			  		  0x5f, 0x41, 0x44, 0x44, 0x0};

	char mask[] = {0x67, 0x49, 0x5D, 0x4B,
		       	   0x78, 0x5E, 0x56, 0x5B};

	char offsets[] = {0x13, 0xF,  0x1F, 0x2,
			  		  0x1B, 0x15, 0x18, 0x6,
			  		  0x12, 0x11, 0x1D, 0xC,
			  		  0x1A, 0x17, 0x9,  0x4};
	int i;
	char ch, sum;

	if (argc == 1)
	{
		protect();
	}

	printf("Give me a key file: ");
	scanf("%s", &name_of_file);
	if ((key = fopen(name_of_file, "rb")) == NULL)
	{
		printf("\nIt's not file!\n");
		exit(0);
	}

	fseek(key, 0, SEEK_END);
	if (ftell(key) != 0x20)
	{
		fail(key);
	}

	fseek(key, 0, SEEK_SET);

	for (i = 0; i < strlen(message); i++)
	{
		sum = 0;
		fseek(key, -(offsets[2*i]), SEEK_END);
		fread(&ch, sizeof(char), 1, key);
		ch -= deductions[2*i];
		if ((ch & 0xF) != 0)
		{
			fail(key);
		}
		sum += ch;
		fseek(key, -(offsets[2*i+1]), SEEK_END);
		fread(&ch, sizeof(char), 1, key);
		ch -= deductions[2*i+1];
		if ((ch & 0xF0) != 0)
		{
			fail(key);
		}
		sum += ch;
		if ((sum ^ mask[i]) != message[i])
		{
			fail(key);
		}
	}

	printf("Good, file is match. And now ");
	printf("%s\n", message);

	fclose(key);
	return 0;
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

void fail(FILE *fil)
{
	printf("\nThis file doesn't match.\n");

	fclose(fil);
	exit(0);
}
