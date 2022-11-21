#!/bin/bash

if [ ! -L SALESDATA ]; then
ln -s ../q01/SALESDATE SALESDATA
fi

cd SALESDATA

#2
grep -r -E "^ J" --include "sales2010*.txt" | wc -l
grep -r -E "^ J" --include "sales2011*.txt" | wc -l
grep -r -E "^ J" --include "sales2012*.txt" | wc -l
grep -r -E "^ J" --include "sales2013*.txt" | wc -l
grep -r -E "^ J" --include "sales2014*.txt" | wc -l
grep -r -E "^ J" --include "sales2015*.txt" | wc -l

#3
grep -r -E "^ J" --include "sales2010w26*.txt" --include "sales2010w27*.txt" --include "sales2010w28*.txt" --include "sales2010w29*.txt" --include "sales2010w30*.txt" --include "sales2010w31*.txt" | grep ", Jul " | wc -l
grep -r -E "^ J" --include "sales2011w26*.txt" --include "sales2011w27*.txt" --include "sales2011w28*.txt" --include "sales2011w29*.txt" --include "sales2011w30*.txt" --include "sales2011w31*.txt" | grep ", Jul " | wc -l
grep -r -E "^ J" --include "sales2012w26*.txt" --include "sales2012w27*.txt" --include "sales2012w28*.txt" --include "sales2012w29*.txt" --include "sales2012w30*.txt" --include "sales2012w31*.txt" | grep ", Jul " | wc -l
grep -r -E "^ J" --include "sales2013w26*.txt" --include "sales2013w27*.txt" --include "sales2013w28*.txt" --include "sales2013w29*.txt" --include "sales2013w30*.txt" --include "sales2013w31*.txt" | grep ", Jul " | wc -l
grep -r -E "^ J" --include "sales2014w26*.txt" --include "sales2014w27*.txt" --include "sales2014w28*.txt" --include "sales2014w29*.txt" --include "sales2014w30*.txt" --include "sales2014w31*.txt" | grep ", Jul " | wc -l
grep -r -E "^ J" --include "sales2015w26*.txt" --include "sales2015w27*.txt" --include "sales2015w28*.txt" --include "sales2015w29*.txt" --include "sales2015w30*.txt" --include "sales2015w31*.txt" | grep ", Jul " | wc -l

#4
grep -r -E "Odyssey" --include "sales2010*.txt" | wc -l
grep -r -E "Odyssey" --include "sales2011*.txt" | wc -l
grep -r -E "Odyssey" --include "sales2012*.txt" | wc -l
grep -r -E "Odyssey" --include "sales2013*.txt" | wc -l
grep -r -E "Odyssey" --include "sales2014*.txt" | wc -l
grep -r -E "Odyssey" --include "sales2015*.txt" | wc -l

#5
grep -r -E "Linda" --include "sales2010*.txt" | wc -l
grep -r -E "Linda" --include "sales2011*.txt" | wc -l
grep -r -E "Linda" --include "sales2012*.txt" | wc -l
grep -r -E "Linda" --include "sales2013*.txt" | wc -l
grep -r -E "Linda" --include "sales2014*.txt" | wc -l
grep -r -E "Linda" --include "sales2015*.txt" | wc -l

#6
grep -r -E "JE142FU154525XBX8"


