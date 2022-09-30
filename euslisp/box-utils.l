(load "package://jsk_pcl_ros/euslisp/bounding-box-to-cube.l")


(defun valid-paper-boxes (msg)
  (let (box)
    (when (> (length (send msg :boxes)) 0)
      (dotimes (i (length (send msg :boxes)))
        (setq box (elt (send msg :boxes) i))
        ;; (print (send box :dimensions :y))
        ;; (print (send box :dimensions :z))
        (when (and (> (send box :dimensions :y) 0.3)
                   (> (send box :dimensions :z) 0.3)
          (return-from valid-paper-boxes box))))
    nil)))


(defun valid-tape-boxes (msg)
  (let (box)
    (when (> (length (send msg :boxes)) 0)
      (dotimes (i (length (send msg :boxes)))
        (setq box (elt (send msg :boxes) i))
        ;; (print (send box :dimensions :y))
        ;; (print (send box :dimensions :z))
        (when (or (< (send box :dimensions :y) 0.1)
                   ;;(< (send box :dimensions :z) 0.1)
                   (< (send box :dimensions :x) 0.1))
          (return-from valid-tape-boxes box))))
    nil))


(defun valid-boxes (msg)
  (let (box)
    (when (> (length (send msg :boxes)) 0)
      (dotimes (i (length (send msg :boxes)))
        (setq box (elt (send msg :boxes) i))
        ;; (print (send box :dimensions :y))
        ;; (print (send box :dimensions :z))
        (when (and (> (send box :dimensions :y) 0.1)
                   ;;(> (send box :dimensions :z) 0.1)
                   (> (send box :dimensions :x) 0.1))
          (return-from valid-boxes box))))
    nil))


(defun tf-pose->coords (frame_id pose)
  (send (send *tfl* :lookup-transform "WAIST" frame_id (ros::time 0))
        :transform (ros::tf-pose->coords pose)))

(defun bbox->cube (bbox)
  (let* ((dims (ros::tf-point->pos (send bbox :dimensions)))
         (bx (make-cube (elt dims 0) (elt dims 1) (elt dims 2))))
    (send bx :newcoords
          (tf-pose->coords (send bbox :header :frame_id) (send bbox :pose)))
    bx))

(defun find-bbox (topic-name &key (condition) (timeout 10))
  (let* (msg
         ros-bbox
         target-bounding-box
         camera-to-box-transform
         base-to-box-transform)

    (while (or (null msg) (= (length (send msg :boxes)) 0))
      (setq msg (one-shot-subscribe topic-name
                                    jsk_recognition_msgs::BoundingBoxArray
                                    :timeout (* timeout 1000)
                                    :condition condition))
      )

    (setq ros-bbox (valid-boxes msg))
    ;; (setq target-bounding-box (bounding-box->cube ros-bbox))

    ;; (setq base-to-camera-transform (send *tfl* :lookup-transform
    ;;                                      "WAIST" (send msg :header :frame_id)
    ;;                                      (ros::time 0)))
    ;; (setq base-to-box-transform
    ;;       (send
    ;;        (send base-to-camera-transform :copy-worldcoords)
    ;;        :transform target-bounding-box))
    ;; (send target-bounding-box :newcoords (send base-to-box-transform :copy-worldcoords))
    (setq target-bounding-box (bbox->cube ros-bbox))
    target-bounding-box))


(defun find-tape-bbox (topic-name &key (condition) (timeout 10))
  (let* (msg
         ros-bbox
         target-bounding-box
         camera-to-box-transform
         base-to-box-transform)

    (while (or (null msg) (= (length (send msg :boxes)) 0))
      (setq msg (one-shot-subscribe topic-name
                                    jsk_recognition_msgs::BoundingBoxArray
                                    :timeout (* timeout 1000)
                                    :condition condition))
      )

    (setq ros-bbox (valid-tape-boxes msg))
    (setq target-bounding-box (bounding-box->cube ros-bbox))

    (setq base-to-camera-transform (send *tfl* :lookup-transform
                                         "base" (send msg :header :frame_id)
                                         (ros::time 0)))
    (setq base-to-box-transform
          (send
           (send base-to-camera-transform :copy-worldcoords)
           :transform target-bounding-box))
    (send target-bounding-box :newcoords (send base-to-box-transform :copy-worldcoords))
    target-bounding-box))

(defun find-paper-bbox (topic-name &key (condition) (timeout 10))
  (let* (msg
         ros-bbox
         target-bounding-box
         camera-to-box-transform
         base-to-box-transform)

    (while (or (null msg) (= (length (send msg :boxes)) 0))
      (setq msg (one-shot-subscribe topic-name
                                    jsk_recognition_msgs::BoundingBoxArray
                                    :timeout (* timeout 1000)
                                    :condition condition))
      )

    (setq ros-bbox (valid-paper-boxes msg))
    (setq target-bounding-box (bounding-box->cube ros-bbox))

    (setq base-to-camera-transform (send *tfl* :lookup-transform
                                         "base" (send msg :header :frame_id)
                                         (ros::time 0)))
    (setq base-to-box-transform
          (send
           (send base-to-camera-transform :copy-worldcoords)
           :transform target-bounding-box))
    (send target-bounding-box :newcoords (send base-to-box-transform :copy-worldcoords))
    target-bounding-box))
