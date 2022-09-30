(load "package://hrpsys_ros_bridge_tutorials/euslisp/hironxjsk-interface.l")
(load "package://hiro_demo/euslisp/topic-utils.l")
(load "package://hiro_demo/euslisp/box-utils.l")
(load "models/arrow-object.l")
(ros::load-ros-package "jsk_recognition_msgs")

(hironxjsk-init)
(objects (list *hironxjsk*))
(send *ri* :angle-vector (send *hironxjsk* :reset-manip-pose))
(send *hironxjsk* :head :look-at
      (send (send (send *hironxjsk* :torso :end-coords :copy-worldcoords)
                  :translate #f(750 0 0)) :worldpos))
(send *irtviewer* :draw-objects)  ;; Only for display
(send *ri* :angle-vector (send *hironxjsk* :angle-vector) 1000)
(send *ri* :wait-interpolation)

(defun detect()
  (setq *box-topic-name* "/segmentation_decomposer/boxes")
  (setq *target-box* (find-bbox *box-topic-name* :condition #'valid-boxes))
  (setq target-box (find-bbox *box-topic-name* :condition #'valid-boxes))
  (setq *target-box-arrow* (arrow))
  (send *target-box-arrow* :newcoords (send target-box :copy-worldcoords))
  (setq box-x (x-of-cube target-box))
  (setq box-y (y-of-cube target-box))
  (setq right-offset-x (- (/ box-x 1.0)))
  (setq left-offset-x (- (/ box-x 1.0)))
  (setq right-offset-y (- (/ box-y 1.0)))
  (setq left-offset-y (- (/ box-y 1.0)))
  (setq yokonaga 1)
  (if (> (abs (elt (send *target-box-arrow* :x-axis) 0)) (abs (elt (send *target-box-arrow* :x-axis) 1))) ;;if true tatenaga
      (setq yokonaga -1))
  (setq direction 1)
  (if  (eq (and (> (elt (send (send target-box :copy-worldcoords) :x-axis) 1) 0) (eq yokonaga 1)) nil)
      (progn
        (send target-box :rotate pi :z)
        (setq direction -1)))
  (if  (eq (and (> (elt (send (send target-box :copy-worldcoords) :x-axis) 0) 0) (eq yokonaga -1)) nil)
      (progn
        (send target-box :rotate pi :z)
        (setq direction -1)))
  (send *target-box* :newcoords (send target-box :copy-worldcoords))
  (send *target-box-arrow* :newcoords (send target-box :copy-worldcoords))

  (objects (list *hironxjsk* *target-box* *target-box-arrow*))
  )
(defun ir2ri (&optional (time 3000))
  (send *ri* :angle-vector (send *hironxjsk* :angle-vector) time)
  )
(defun ri2ir ()
  (send *hironxjsk* :angle-vector (send *ri* :state :potentio-vector)))






;; (send *ri* :remove-joint-group "rarm")
;; (send *ri* :remove-joint-group "larm")
;; (send *ri* :remove-joint-group "torso")
;; (send *ri* :remove-joint-group "head")
