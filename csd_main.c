int csd_main()
{
	register int current asm("r2");
	//int current = 10000; //for test
	int digit = 0;
	digit = digit | (current % 60);
	digit = digit | ((current / 60) % 60) << 8;
	digit = digit | ((current/3600)) << 16;

	return digit;

}


