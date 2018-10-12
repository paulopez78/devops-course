set -e
. common.sh $1

voting_options="python bash go"
voted_options="python go bash bash"
expected_winner="bash"

echo "Given [$voting_options] voting options"
echo "When voted for [$voted_options]"
echo "Then winner is $expected_winner"
 
start_voting "$voting_options"

for topic in $voted_options
do
  vote $topic
done

winner=$(finish_voting)
assert_equal $expected_winner $winner 
