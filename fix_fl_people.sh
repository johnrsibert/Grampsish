#!/bin/bash
if [ $# -lt 1 ];then
    echo "Utility to replace list of People of Ineterst in Gramps Family Lines Graph."
    echo "The file 'report_options.xml' is overwritten after making a backup."
    echo "The current list of People of Ineterst is saved for possible reuse" 
    echo "Usage: "$0" current_pid [new_pid]"
    echo "   current_pid is the file name in which to save current pid list"
    echo "   Optional. If present, new_pid is the name of the file containing"
    echo "   the new pid list"
    echo "   eg " $0" bigfamily.pid three_gen.pid"
    exit 1
fi 

gramps_home=~/.gramps/
#echo "gramps_home = "$gramps_home
opts=$gramps_home"report_options.xml"
#echo "opts = "$opts
bak=$opts".bak"
#echo "bak = "$bak

echo "Backing up "$opts " to " $bak 
cp -irp $opts $bak

echo "Saving current pid list to "$gramps_home$1
lxprintf -e 'module[@name="familylines_graph"]/option[@name="gidlist"]'\
 "%s\n" @value $opts > $gramps_home$1

echo "Replacing pids in "$opts
echo "    with the contents of "$gramps_home$2

# replacing the dat in situ does not seem to work correctly
# instead send it to a temporary file and copy
lxreplace -q \
  'module[@name="familylines_graph"]/option[@name="gidlist"]' \
  -@ '"value"' "&apos;`cat $gramps_home$2`&apos;" \
  ~/.gramps/report_options.xml > /tmp/temp.xml

cp -fv /tmp/temp.xml $opts 2>>/dev/null
echo "Updated "$opts
