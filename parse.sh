#!/usr/bin/bash
for i in {0..99}
do
  filename="./www/${i}.html"
  log[${i}]=`cat ${filename} | grep "<p>" | sed 's/<[^>]*>//g'`
done

rm words.txt 2> /dev/null
for i in {0..99}
do
  echo ${log[${i}]} | grep -io "[a-z]*" | tr "[:upper:]" "[:lower:]" >> "words.txt"
done

rm word_count.txt 2> /dev/null
declare -A sum
for word in `cat words.txt`
do
  let sum[$word]++
done

rm changelist.txt 2> /dev/null
declare -A to
eval `cat ir_v_map.txt`
eval `cat ir_n_map.txt`

for word in ${!sum[*]}
do
# deal with irregular forms  reference: irregular_nouns.txt irregular_verbs.txt
  sub=${to[$word]}
  if test $sub != "" 2>> /dev/null ; then
    echo "$sub , $word" >> changelist.txt
    let sum[$sub]++
    sum[$word]=
    continue
  fi

# regular forms
# verb-d
# verb-ed
# verb-double-ed
# noun-s
# noun-es
# noun-double-es
  l=${#word}
  if test $l -le 3 ; then
    continue
  fi

  if test "${word:${l}-1}" = "d" ; then
    sub=${word:0:${l}-1}
    # echo $sub
    if test ${sum[$sub]} -gt 0 2>> /dev/null; then
      echo "$sub , $word" >> changelist.txt
      let sum[$sub]++
      sum[$word]=
      continue
    fi
  fi

  if test "${word:${l}-2}" = "ed" ; then
    sub=${word:0:${l}-2}并
    if test ${sum[$sub]} -gt 0 2>> /dev/null; then
      echo "$sub , $word" >> changelist.txt
      let sum[$sub]++
      sum[$word]=
      continue
    fi

    # deal with double suffix like stopped
    sub=${word:0:${l}-3}
    if test ${sum[$sub]} -gt 0 2>> /dev/null; then
      if test ${word:$l-3:l-2} = ${word:$l-3:l-2} ; then
        echo "$sub , $word" >> changelist.txt
        let sum[$sub]++
        sum[$word]=
        continue
      fi
    fi
  fi

  if test "${word:${l}-1}" = "s" ; then
    sub=${word:0:${l}-1}
    # echo $sub
    if test ${sum[$sub]} -gt 0 2>> /dev/null; then
      echo "$sub , $word" >> changelist.txt
      let sum[$sub]++
      sum[$word]=
      continue
    fi
  fi

  if test "${word:${l}-2}" = "es" ; then
    sub=${word:0:${l}-2}
    # echo $sub
    if test ${sum[$sub]} -gt 0 2>> /dev/null; then
      echo "$sub , $word" >> changelist.txt
      let sum[$sub]++
      sum[$word]=
      continue
    fi

    # deal with double suffix like quizzes
    sub=${word:0:${l}-3}
    if test ${sum[$sub]} -gt 0 2>> /dev/null; then
      if test ${word:$l-3:l-2} = ${word:$l-3:l-2} ; then
        echo "$sub , $word" >> changelist.txt
        let sum[$sub]++
        sum[$word]=
        continue
      fi
    fi
  fi

done

for i in ${!sum[*]}
do
  echo "${i} : ${sum[${i}]}" >> "word_count.txt"
done
# sort and select first 1000 lines
sort -t: -k 2,2 -nr word_count.txt | sed '1000q' > answer.txt
