#!/usr/bin/awk -f
{
  for (i = 2;i <= NF - 1; i ++)
  {
    if ($i != $1)
    {
      print "to["$i"]="$1
    }
  }
}

# ./irreg.sh irregular_nouns > ir_n_map.txt
# ./irreg.sh irregular_vouns > ir_v_map.txt
