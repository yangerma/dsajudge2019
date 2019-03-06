#!/usr/bin/env bash
#cd "$( dirname "${BASH_SOURCE[0]}" )"
#DIR="$(cd -P "$(dirname "$0")" && pwd)"

export PATH='/home/mvnl/bin:/home/mvnl/.local/bin:/home/mvnl/.nvm/versions/node/v10.10.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin'
cd -P "$(dirname "$0")"
backup_dir=../DSA2019_backup
DATE=`date +%Y%m%d-%H%M%S`
#echo ${DATE}' '${PATH}

root_dir=$backup_dir/$DATE
submissions_dir=./submissions
homeworks_dir=./homeworks
problems_dir=./problems
git_dir=/home/git/repositories
gitosis_admin=./gitosis-admin
mkdir -p $root_dir
mongodump --archive=$root_dir/dsajudge.${DATE}.gz --gzip --db dsajudge
tar -zcf $root_dir/submissions.tar.gz $submissions_dir
tar -zcf $root_dir/homeworks.tar.gz $homeworks_dir
tar -zcf $root_dir/git.tar.gz $git_dir
tar -zcf $root_dir/problems.tar.gz $problems_dir/*/prob.md
tar -zcf $root_dir/gitosis_admin.tar.gz $gitosis_admin
#gdrive upload -r $root_dir

rm /tmp/log -f
echo ------${DATE}------ >>/tmp/count
gdrive sync upload $backup_dir 15PpjlB5g5yy_Au9-D7jegJoh1obCDbDz | tee /tmp/log
echo oops >>/tmp/log
while [ "$(cat /tmp/log | tee /tmp/current | grep finished | wc -c)" == 0 ]; do
	sleep 2
	echo try >>/tmp/count
	gdrive sync upload $backup_dir 15PpjlB5g5yy_Au9-D7jegJoh1obCDbDz | tee /tmp/log
done
echo ======${DATE}====== >>/tmp/count

# True backup starts from 2019/02/28
