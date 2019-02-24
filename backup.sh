#/bin/bash
#cd "$( dirname "${BASH_SOURCE[0]}" )"
#DIR="$(cd -P "$(dirname "$0")" && pwd)"
cd -P "$(dirname "$0")"
backup_dir=../DSA2019_backup
DATE=`date +%Y%m%d-%H%M%S`
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
gdrive upload -r $root_dir
gdrive sync upload $backup_dir 15PpjlB5g5yy_Au9-D7jegJoh1obCDbDz >/tmp/log
while [ "$(cat /tmp/log | grep finished | wc -c)" == 0 ]; do
	sleep 5
	gdrive sync upload $backup_dir 15PpjlB5g5yy_Au9-D7jegJoh1obCDbDz >/tmp/log
	#echo attempt >>/tmp/count
done
