(load "package://hrpsys_ros_bridge_tutorials/euslisp/hironxjsk-interface.l")
(load "package://roseus_resume/euslisp/interruption-handler.l")
(ros::load-ros-package "jsk_recognition_msgs")

(hironxjsk-init)
(roseus_resume::install-intervention-handler *ri*)
(roseus_resume:defintervention
 collision "/collision" std_msgs::String :groupname (*ri* . groupname))
(ros::roseus "collision_detect_client")
;; (ros::wait-for-service "/CollisionDetectorServiceROSBridge/getCollisionStatus")
(setq *service-name* "/CollisionDetectorServiceROSBridge/getCollisionStatus")
(setq req (instance hrpsys_ros_bridge::OpenHRP_CollisionDetectorService_getCollisionStatusRequest :init))
(setq collision-list (send (ros::service-call *service-name* req) :cs :collide))

;;if more than one element of collision-list is true, pub
(dolist (x collision-list)
  (if (equal x t)
      (progn
        (
        (return))))
