#!/bin/bash

# Example usage:
# # Run first quarter (0.0-0.2)
# ./run_curriculum.sh 0

# # Run second quarter (0.3-0.5)
# ./run_curriculum.sh 1

# # Run third quarter (0.6-0.8)
# ./run_curriculum.sh 2

# # Run final quarter (0.9-1.0)
# ./run_curriculum.sh 3

# Check if argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <section: 0, 1, 2, 3 or 4>"
    # echo "  0: runs initial_tfr from 0.0 to 0.2"
    # echo "  1: runs initial_tfr from 0.3 to 0.5"
    # echo "  2: runs initial_tfr from 0.6 to 0.8"
    # echo "  3: runs initial_tfr from 0.9 to 1.0"
    exit 1
fi

section=$1

# Validate input argument
if [[ ! "$section" =~ ^[0-4]$ ]]; then
    echo "Error: Invalid section. Must be 0, 1, 2, 3 or 4."
    exit 1
fi

# Define the ranges for each section
case $section in
    0)
        initial_tfrs=(0.1 0.2)
        ;;
    1)
        initial_tfrs=(0.3 0.4 )
        ;;
    2)
        initial_tfrs=(0.5 0.6 )
        ;;
    3)
        initial_tfrs=(0.7 0.8)
        ;;
    4)
        initial_tfrs=(0.9 1.0)
        ;;
esac

future_len=400
past_len=800
num_epochs=100

if [[ "$section" =~ ^[0]$ ]]; then
    # Run with no TFR
    echo "[Section $section] [$(date +%F\ %T)] Running constant method with initial_tfr 0 (no tfr)." >> curriculum_log.txt
    python3 a2_curriculum.py --curriculum_method=constant --initial_tfr=0 --past_len=$past_len --future_len=$future_len --num_epochs=$num_epochs
    echo "[Section $section] [$(date +%F\ %T)] Finished constant method with initial_tfr 0 (no tfr)." >> curriculum_log.txt
    # Run with proportional method - not affected by initial TFR
    for factor in 0.2 0.4 0.6 0.8 1.0
    do
        echo "[Section $section] [$(date +%F\ %T)] Running proportional method with factor $factor." >> curriculum_log.txt
        python3 a2_curriculum.py --curriculum_method=proportional --initial_tfr=1 --proportional_method_factor=$factor --past_len=$past_len --future_len=$future_len --num_epochs=$num_epochs
        echo "[Section $section] [$(date +%F\ %T)] Finished proportional method with factor $factor." >> curriculum_log.txt
    done
fi

# Main execution loop
for initial_tfr in "${initial_tfrs[@]}"
do
    echo "[Section $section] [$(date +%F\ %T)] Running with initial_tfr = $initial_tfr" >> curriculum_log.txt 
    
    # Constant
    echo "[Section $section] [$(date +%F\ %T)] Running constant method with initial_tfr $initial_tfr." >> curriculum_log.txt
    python3 a2_curriculum.py --curriculum_method=constant --initial_tfr=$initial_tfr --past_len=$past_len --future_len=$future_len --num_epochs=$num_epochs
    echo "[Section $section] [$(date +%F\ %T)] Finished constant method with initial_tfr $initial_tfr." >> curriculum_log.txt

    # Linear
    echo "[Section $section] [$(date +%F\ %T)] Running linear method with initial_tfr $initial_tfr." >> curriculum_log.txt
    python3 a2_curriculum.py --curriculum_method=linear --initial_tfr=$initial_tfr --past_len=$past_len --future_len=$future_len --num_epochs=$num_epochs
    echo "[Section $section] [$(date +%F\ %T)] Finished linear method with initial_tfr $initial_tfr." >> curriculum_log.txt

    # Exponential
    for factor in 0.1 0.01 0.001
    do
        echo "[Section $section] [$(date +%F\ %T)] Running exponential method with initial_tfr $initial_tfr and factor $factor." >> curriculum_log.txt
        python3 a2_curriculum.py --curriculum_method=exponential --exponential_method_factor=$factor --initial_tfr=$initial_tfr --past_len=$past_len --future_len=$future_len --num_epochs=$num_epochs
        echo "[Section $section] [$(date +%F\ %T)] Finished exponential method with initial_tfr $initial_tfr and factor $factor." >> curriculum_log.txt
    done
done

echo "Completed section $section"