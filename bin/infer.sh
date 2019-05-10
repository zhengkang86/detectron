#!/bin/bash

# python tools/infer_simple_segments.py \
#     --cfg configs/12_2017_baselines/e2e_mask_rcnn_R-101-FPN_2x.yaml \
#     --output-dir /tmp/detectron-visualizations \
#     --image-ext jpg \
#     --wts https://dl.fbaipublicfiles.com/detectron/35861858/12_2017_baselines/e2e_mask_rcnn_R-101-FPN_2x.yaml.02_32_51.SgT4y1cO/output/train/coco_2014_train:coco_2014_valminusminival/generalized_rcnn/model_final.pkl \
#     /home/user/workspace/cvpi/data/images/seq1/cam1/person001

dir_in=/home/user/workspace/cvpi/data/images
dir_out=/home/user/workspace/cvpi/data/masks

# dataset for-loop
for dataset in seq1 seq2 syn
do
    echo "--------"
    echo $dataset
    mask_dataset_dir="$dir_out/$dataset"
    echo $mask_dataset_dir
    mkdir $mask_dataset_dir

    # print number of subjects
    if [ $dataset = seq1 ]
    then
        num_ids=118
    elif [ $dataset = seq2 ]
    then
        num_ids=88
    else
        num_ids=208
    fi
    echo "$num_ids subjects"


    # camera for-loop
    for cam in cam1 cam2
    do
        echo "----"
        echo $cam
        mask_cam_dir="$mask_dataset_dir/$cam"
        echo $mask_cam_dir
        mkdir $mask_cam_dir

        # subject for-loop
        for i in $(seq -w 001 $num_ids)
        do
            echo $i
            mask_person_dir="$mask_cam_dir/person$i"
            echo $mask_person_dir
            mkdir $mask_person_dir

            # run segmentation
            img_dir="$dir_in/$dataset/$cam/person$i"
            python tools/infer_simple_segments.py \
                --cfg configs/12_2017_baselines/e2e_mask_rcnn_R-101-FPN_2x.yaml \
                --output-dir $mask_person_dir \
                --image-ext jpg \
                --wts https://dl.fbaipublicfiles.com/detectron/35861858/12_2017_baselines/e2e_mask_rcnn_R-101-FPN_2x.yaml.02_32_51.SgT4y1cO/output/train/coco_2014_train:coco_2014_valminusminival/generalized_rcnn/model_final.pkl \
                $img_dir
        done
    done
done
