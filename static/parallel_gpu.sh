#!/usr/bin/env bash

export CFG_NAME='cfg'

export CUDA_VISIBLE_DEVICES=7,6

labels=('hoge' 'fuga')

total_runs="${#labels[@]}"
gpu_count=$(echo "$CUDA_VISIBLE_DEVICES" | sed 's/,/\n/g' | wc -l)
cmd_base="echo"
mgr_opts="--help"

echo "gpu_count=$gpu_count"
echo "total_runs=$total_runs"

cmdname () {
  echo "echo CUDA_VISIBLE_DEVICES=$1 done"
}

range () {
  seq 0 $1 | sed -e '$ d'
}

nth_device () {
  nth=$(($1+1))
  echo "$CUDA_VISIBLE_DEVICES" | sed 's/,/\n/g' | sed "${nth}q;d"
}

cmd="true"
for chunk_id in $(range $gpu_count); do
  echo "$(cmdname $(nth_device $chunk_id))"
  cmd="$cmd & ( $(cmdname $(nth_device $chunk_id)) )"
done

for run_id in $(range $total_runs); do
  gpu_id=$(expr $run_id % $gpu_count)
  gpu_num=$(nth_device $gpu_id)
  exp_name="${CFG_NAME}-${labels[$run_id]}"
  cur_cmd="CUDA_VISIBLE_DEVICES=$gpu_num $cmd_base '$exp_name' '$CFG_NAME'"
  cur_cmd="$cur_cmd MODULE.LABEL_ONLY='${labels[$run_id]}' $mgr_opts $@"
  [[ $gpu_id -gt 0 ]] && cur_cmd="$cur_cmd USE_TRACK=false --log_file=./logs/$exp_name.log --log_overwrite"
  cmd=${cmd/$(cmdname $gpu_num)/$cur_cmd ; $(cmdname $gpu_num)}
done

echo $cmd

(trap 'kill 0' SIGINT; eval "$cmd"; wait) \
  && echo "$cmd_base $mgr_opts is done" \
  || (echo "$cmd_base $mgr_opts FAILED"; exit 1)
