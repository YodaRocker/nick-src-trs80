/* Merge.c: Merge two files columnwise.
 * Ported off the Crappywell L/66 'merge.b'
 * Nick Andrew.
 */

#include <stdio.h>
#define STRLENGTH 180

char  l1[STRLENGTH],
      c1[STRLENGTH],
      n1[STRLENGTH],
      l2[STRLENGTH],
      c2[STRLENGTH],
      n2[STRLENGTH];

int tabs=0;

main(argc,argv)
int argc;
char *argv[];
{
char *lastl1, *currl1, *nextl1;
char *lastl2, *currl2, *nextl2, *temp;
FILE *unit1,  *unit2,  *unit3;
int  column;

if (argc<5) {
   printf("Usage: merge [-t] infile infile outfile column\n");
   exit(1);
}

++argv;
while (--argc > 4)
   if (**argv=='-') {
      tabs=1;
      ++argv;
   }

column=atoi(argv[3]);  /* Get merging column */
if (tabs) column=((column+8) % 8); /* adjust for tabs */
unit1=fopen(argv[0],"r");          /* Open all files  */
unit2=fopen(argv[1],"r");
unit3=fopen(argv[2],"w");

if (unit1==NULL || unit2==NULL || unit3==NULL) {
   printf("merge: can't open files!\n");
   exit(2);
}

   lastl1 = l1;
   currl1 = c1;
   nextl1 = n1;
   lastl2 = l1;
   currl2 = c2;
   nextl2 = n2;

   (*lastl1) = (*lastl2) = 0;  /* set to null strings */
   rdline(currl1,unit1);       /* Read current & next */
   rdline(currl2,unit2);
   rdline(nextl1,unit1);
   rdline(nextl2,unit2);
   /* while not both eof */
   while (!((*currl1==0) && (*currl2==0)))
      {
      if ((max3str(currl1,lastl1,nextl1)>=column) ||
          (strlen(currl2)==0))
         fprintf(unit3,currl1,"",strlen(currl1));
      else {
         wrline(unit3,currl1,currl2,column);
         temp=lastl2;
         lastl2=currl2;
         currl2=nextl2;
         nextl2=temp;
         rdline(nextl2,unit2);
      }
      temp=lastl1;
      lastl1=currl1;
      currl1=nextl1;
      nextl1=temp;
      rdline(nextl1,unit1);
   }
}

rdline(string,unit)
char string[];
FILE *unit;
{
   int chars;
   char c;
   chars=0;
   c=((c=getc(unit))==EOF ? 0 : c);
   while (c) {
      string[chars++]=c;
      if (c=='\n') break;
      c=((c=getc(unit))==EOF ? 0 : c);
   }
   string[chars]=0;
}

wrline(unit,string1,string2,column)
FILE *unit;
char *string1,*string2;
int column;
{
   int i;
   if (*string2==0) fprintf(unit,"%s",string1);
    else {
      for (i=0;i<strlen(string1)-1;i++) putc(string1[i],unit);
      for (i=1;i<(column-strlenp(string1));i++) putc(' ',unit);
      fputs(string2,unit);
   }
}

max3str(str1,str2,str3)
char *str1,*str2,*str3;
{
int s1,s2,s3,m1;
s1=strlenp(str1);
s2=strlenp(str2);
s3=strlenp(str3);
m1=s1;
if (s2>m1) m1=s2;
if (s3>m1) m1=s3;
return (m1);
}

int strlenp(string)
char *string;
{
   int i,col;
   i=col=0;
   while (string[i])
      if (string[i++]=='\t') col+=(8- (col % 8));
      else col++;
   return(col);
}
