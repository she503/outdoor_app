import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
Rectangle {
    id: root
    visible: true
    width: parent.width
    height: parent.height
    clip: true
    color: "transparent"

    property alias p_choose_marker: choose_marker
    property alias a_vehicle: vehicle
    property var p_task_points: []
    property var p_task_regions: []
    property var p_task_lines: []

    property var paint_begin_offset: 20

    property var var_trees: []
    property var var_signals: []
    property var var_stop_signs: []
    property var var_speed_bumps: []
    property var var_road_edges: []
    property var var_lane_lines: []
    property var var_clear_areas_include: []
    property var var_crosswalks: []
    property var var_junctions: []
    property var var_parking_spaces: []
    property var var_roads_include: []
    property var var_roads_exclude: []

    property var var_obstacles: []
    property var obstacles_is_polygon: []
    property var var_ref_line: []
    property real ref_line_curren_index: 0
    property var var_planning_path: []
    property var var_planning_ref_path: []
    property var var_trajectory: []


    property real map_width: 0
    property real map_height: 0
    property real map_rate: 1
    property real min_x: Number.POSITIVE_INFINITY
    property real min_y: Number.POSITIVE_INFINITY
    property real max_y: Number.NEGATIVE_INFINITY
    property real max_x: Number.NEGATIVE_INFINITY
    property real real_rate: 2.5

    property bool can_drag: true
    property var choosePoint: []


    property var begin_points: []
    property var charge_points: []
    property bool could_select_begin_point: status_manager.getWorkStatus() <= status_manager.getSelectTaskID()
    property bool is_select_begin_point: false

    property var lo_x: 0
    property var lo_y: 0


    function paintTasks(){
        canvas_task.requestPaint()
    }

    function paintingMap(current_map_name) {
        if(current_map_name === "") {
            return
        }

        map.scale = 1 / root.real_rate
        min_x = Number.POSITIVE_INFINITY
        min_y = Number.POSITIVE_INFINITY
        max_y = Number.NEGATIVE_INFINITY
        max_x = Number.NEGATIVE_INFINITY

        var feature_list = map_task_manager.getMapFeature(map_task_manager.getCurrentMapName())
        if (feature_list.length === 1) {
            root.begin_points = feature_list[0]
        } else if (feature_list.length === 2) {
            root.begin_points = feature_list[0]
            root.charge_points = feature_list[1]
        } else if (feature_list.length === 0) {
            root.begin_points = []
            root.charge_points = []
        }
        root.is_select_begin_point = false



        var work_status = status_manager.getWorkStatus()
        var map_road_data = []
        var map_road_edges_data = []
        map_road_edges_data = map_task_manager.getMapRoadEdges(current_map_name)
        map_road_data = map_task_manager.getMapRoads(current_map_name)

        root.var_road_edges = map_road_edges_data
        root.var_roads_include = map_road_data[0]
        root.var_roads_exclude = map_road_data[1]

        var all_x = []
        var all_y = []

        for (var i = 0; i < var_road_edges.length; ++i) {
            for (var j = 0; j < var_road_edges[i][0].length; ++j) {
                var pos_x = var_road_edges[i][0][j][0]
                var pos_y = var_road_edges[i][0][j][1]
                min_x = Math.min(min_x, pos_x)
                max_x = Math.max(max_x, pos_x)
                min_y = Math.min(min_y, pos_y)
                max_y = Math.max(max_y, pos_y)

            }
        }
        for (var p = 0; p < var_roads_include.length; ++p) {
            for (var q = 0; q < var_roads_include[p].length; ++q) {
                var pos_x = var_roads_include[p][q][0]
                var pos_y = var_roads_include[p][q][1]
                all_x.push(pos_x)
                all_y.push(pos_y)
                min_x = Math.min(min_x, pos_x)
                max_x = Math.max(max_x, pos_x)
                min_y = Math.min(min_y, pos_y)
                max_y = Math.max(max_y, pos_y)
            }
        }

        map_width = max_x - min_x
        map_height = max_y - min_y

        map_rate = map_width > map_height ? (map.width / map_width) :
                                            (map.height / map_height)

        map_rate *= real_rate

        map.x = (map.width - canvas_background.width) / 2 / root.real_rate + root.paint_begin_offset * 2
        map.y = (map.height - canvas_background.height) / 2 / root.real_rate

        canvas_background.requestPaint()


        //        var vehicle_width = 4.4
        //        var vehicle_height = 2.2

        var vehicle_width = vehicle_info_manager.getVehicleWidth()
        var vehicle_height = vehicle_info_manager.getVehicleHeight()

        vehicle.width =  vehicle_width * 3/2 * map_rate
        vehicle.height = vehicle_height * map_rate

//        createBeginPoint(0)
    }

    function geometryToPixel(X, Y) {
        var x = (X - min_x) * map_rate + paint_begin_offset
        var y = (Y - max_y) * -map_rate + paint_begin_offset

        return [x, y]
    }

    function pixelToGeometry(X, Y) {
        var x = (X - paint_begin_offset) / map_rate + min_x
        var y = (Y - paint_begin_offset) / -map_rate + max_y
        return [x, y]
    }

    function clearAllCanvas() {
        var_obstacles = []
        obstacles_is_polygon = []
        var_ref_line = []
        ref_line_curren_index = 0
        var_planning_path = []
        var_planning_ref_path = []
        var_trajectory = []
        p_task_points = []
        p_task_regions = []
        p_task_lines = []
        canvas_task.requestPaint()
        canvas_obstacles.requestPaint()
        canvas_ref_line.requestPaint()
        canvas_red_ref_line.requestPaint()
        canvas_planning_ref_line.requestPaint()
    }

    function drawLine2d(ctx, points, color) {
        if (points.length <= 0) {
            return
        }
        ctx.save()
        ctx.lineWidth = 1
        ctx.strokeStyle = color
        ctx.beginPath()
        var first_pointt = geometryToPixel(points[0][0], points[0][1])
        ctx.moveTo(first_pointt[0], first_pointt[1])
        for (var i = 0; i < points.length; ++i) {
            var point = geometryToPixel(points[i][0], points[i][1])
            ctx.lineTo(point[0], point[1])
        }
        ctx.stroke()
        ctx.restore()
    }

    Component.onCompleted: {
        var work_status = status_manager.getWorkStatus()
        var current_map_name = map_task_manager.getCurrentMapName()
        root.paintingMap(current_map_name)
        if (work_status === status_manager.getWorkingID()) {
            root.var_ref_line = map_task_manager.getWorkFullRefLine()
            canvas_ref_line.requestPaint()
        }
    }

    Connections {
        target: status_manager
        onWorkStatusUpdate: {
            if (status === status_manager.getSelectMapID()) {
                canvas_background.requestPaint()
                root.paintingMap(map_task_manager.getCurrentMapName())
            }

            if (status <= status_manager.getLocationComfirmID()) {
                root.could_select_begin_point = true
            } else {
                root.could_select_begin_point = false
            }

            if (status > status_manager.getLocationComfirmID()) {
//                vehicle.x = 0
//                vehicle.y = 0
//                vehicle.rotation = 0
                var pixel_pos = geometryToPixel(root.lo_x, root.lo_y)
                vehicle.x = pixel_pos[0] - vehicle.width / 2
                vehicle.y = pixel_pos[1] - vehicle.height / 2
            }
            if (status !== status_manager.getWorkingID()) {
                canvas_trajectory.clean_all = true
                ros_message_manager.clearLastTrajectory()
            }


        }
    }

    Connections {
        target: map_task_manager
        onEmitWorkFullRefLine: {
            root.var_ref_line = ref_line
            canvas_ref_line.requestPaint()
        }
        onEmitLocalizationInfo: {
            vehicle.visible = true
            var pixel_pos = geometryToPixel(x, y)
            vehicle.x = pixel_pos[0] - vehicle.width / 2
            vehicle.y = pixel_pos[1] - vehicle.height / 2
            //            if (!root.can_drag) {
            //                map.x = (map.width / 2 - vehicle.x + vehicle.width / 2) * (map.scale)
            //                map.y = (map.height / 2 - vehicle.y + vehicle.height / 2) * (map.scale)
            //            }
            vehicle.rotation = -heading_angle
            root.lo_x = x
            root.lo_y = y
        }


    }

    Connections {
        target: ros_message_manager
        onUpdateLocalizationInfo: {
            vehicle.visible = true
            var pixel_pos = geometryToPixel(x, y)
            vehicle.x = pixel_pos[0] - vehicle.width / 2
            vehicle.y = pixel_pos[1] - vehicle.height / 2
            if (!root.can_drag) {
                map.x = (map.width / 2 - vehicle.x + vehicle.width / 2) * (map.scale)
                map.y = (map.height / 2 - vehicle.y + vehicle.height / 2) * (map.scale)
            }
            vehicle.rotation = -heading
            root.lo_x = x
            root.lo_y = y
        }
        onUpdateObstacleInfo: {
            var_obstacles = obstacles
            obstacles_is_polygon = is_polygon
            canvas_obstacles.requestPaint()
        }
        onUpdatePlanningInfo: {
            var_planning_path = planning_path
            canvas_planning_ref_line.requestPaint()
        }
        onUpdatePlanningRefInfo: {
            root.var_planning_ref_path = planning_path
            canvas_planning_ref_line.requestPaint()
        }
        onUpdateTaskProcessInfo: {
            ref_line_curren_index = current_index
            if (ref_line_curren_index === 0) {
                return
            }
            canvas_red_ref_line.requestPaint()
        }
        onUpdateTrajectoryInfo: {
            canvas_trajectory.clean_all = false
            var_trajectory = trajectory
            canvas_trajectory.requestPaint()
        }
    }

    onHeightChanged: {
        map.x = (map.width - canvas_background.width) / 2 / root.real_rate + root.paint_begin_offset * 2
        map.y = (map.height - canvas_background.height) / 2 / root.real_rate

    }

    onWidthChanged: {
        map.x = (map.width - canvas_background.width) / 2 / root.real_rate + root.paint_begin_offset * 2
        map.y = (map.height - canvas_background.height) / 2 / root.real_rate

    }

    Rectangle {
        id: map
        width: parent.width * 0.78
        height: parent.height
        color: "transparent"
        Image {
            id: choose_marker
            z: 1
            visible: false
            source: "qrc:/res/pictures/gps.png"
            width: 0
            height: 0
            x: choosePoint[0] - width / 2
            y: choosePoint[1] - height
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            id: map_background
            width: canvas_background.width
            height: canvas_background.height
            color: "transparent"
            Canvas {
                id: canvas_background
                width: map_width * map_rate + paint_begin_offset * 2
                height: map_height * map_rate + paint_begin_offset * 2

                function cacuDis(sx,sy,tx,ty){
                    return Math.sqrt(Math.pow(tx-sx,2)+Math.pow(ty-sy,2))
                }

                function drawRoadEdge(ctx, var_road_edges) {
                    if (var_road_edges.length <= 0) {
                        return
                    }

                    ctx.save()
                    ctx.beginPath()
                    for (var i = 0; i < var_road_edges.length;  ++i) {
                        var first_point = geometryToPixel(var_road_edges[i][0][0][0], var_road_edges[i][0][0][1])
                        ctx.moveTo(first_point[0], first_point[1])
                        for (var j = 1; j < var_road_edges[i][0].length; ++j) {
                            var point = geometryToPixel(var_road_edges[i][0][j][0], var_road_edges[i][0][j][1])
                            ctx.lineTo(point[0], point[1])
                        }
                    }
                    ctx.stroke()
                    ctx.restore()
                }

                function drawExcludeArea(ctx, exclude_area, color, line_width) {
                    if (exclude_area.length <= 0) {
                        return
                    }
                    ctx.save()
                    ctx.beginPath()
                    ctx.lineWidth = line_width
                    ctx.fillStyle = color//"#696969"
                    for (var i = 0; i < exclude_area.length;  ++i) {
                        var first_point = geometryToPixel(exclude_area[i][0][0], exclude_area[i][0][1])
                        ctx.moveTo(first_point[0], first_point[1])
                        for (var j = 0; j < exclude_area[i].length; ++j) {
                            var point = geometryToPixel(exclude_area[i][j][0], exclude_area[i][j][1])
                            ctx.lineTo(point[0], point[1])
                        }
                        ctx.lineTo(first_point[0], first_point[1])
                    }
                    ctx.closePath()
                    ctx.stroke()
                    ctx.fill()
                    ctx.restore()
                }

                function drawIncludeArea(ctx, include_area, color, line_width) {
                    if (include_area.length <= 0) {
                        return
                    }

                    ctx.save()
                    ctx.beginPath()
                    ctx.fillStyle = color
                    ctx.lineWidth = line_width
                    for (var i = 0; i < include_area.length;  ++i) {
                        var first_point = geometryToPixel(include_area[i][0][0], include_area[i][0][1])
                        ctx.moveTo(first_point[0], first_point[1])
                        for (var j = 0; j < include_area[i].length; ++j) {
                            var point = geometryToPixel(include_area[i][j][0], include_area[i][j][1])
                            ctx.lineTo(point[0], point[1])
                        }
                    }
                    ctx.closePath()
                    ctx.fill()
                    ctx.stroke()
                    ctx.restore()
                }

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0,0,canvas_background.width,canvas_background.height)
                    drawIncludeArea(ctx, var_roads_include, "rgba(0,255,0,0.05)", 0)
                    drawExcludeArea(ctx, var_roads_exclude, "grey", 1.5)
                    drawRoadEdge(ctx, var_road_edges)

                    drawLine2d(ctx, root.var_ref_line, "#ff0000")
                }
            }

            Canvas {
                id: canvas_task
                width: map_width * map_rate  + paint_begin_offset * 2
                height: map_height * map_rate + paint_begin_offset * 2

                x: canvas_background.x
                y: canvas_background.y

                function drawPoint(ctx, points){
                    if (points.length <= 0) {
                        return;
                    }

                    ctx.save()
                    ctx.strokeStyle = "#00ff00"
                    ctx.fillStyle = "rgba(238,64,0,0.5)"
                    for (var i = 0 ; i < points.length; ++i) {
                        for (var j = 0; j < points[i].length; ++j) {
                            var point = geometryToPixel(points[i][j][0], points[i][j][1])
                            ctx.beginPath()
                            ctx.arc(point[0],point[1],4,0,2*Math.PI)
                            ctx.fill()
                            ctx.stroke()
                        }
                    }
                    ctx.restore()
                }

                function drawRegion(ctx, points){
                    if (points.length <= 0) {
                        return;
                    }

                    ctx.save()
                    ctx.strokeStyle = "#ff4000"
                    ctx.fillStyle = "rgba(0,244,0,0.5)"
                    for (var j = 0; j < points.length; ++j) {
                        ctx.beginPath()
                        var first_point = geometryToPixel(points[j][0][0], points[j][0][1])
                        ctx.moveTo(first_point[0], first_point[1])
                        for (var i = 1; i < points[j].length; ++i) {
                            var point = geometryToPixel(points[j][i][0], points[j][i][1])
                            ctx.lineTo(point[0], point[1])
                        }
                        ctx.lineTo(first_point[0], first_point[1])
                        ctx.closePath()
                        ctx.fill()
                        ctx.stroke()
                    }
                    ctx.restore()
                }

                function drawLine(ctx, points){
                    if (points.length <= 0) {
                        return
                    }

                    ctx.save()
                    ctx.lineWidth = 0.5
                    ctx.strokeStyle = "#00ff00"
                    for (var j = 0; j < points.length; ++j) {
                        ctx.beginPath()
                        var first_point = geometryToPixel(points[j][0], points[j][1])
                        ctx.moveTo(first_point[0], first_point[1])
                        for (var i = 0; i < points[j].length; ++i) {
                            var point3 = geometryToPixel(points[j][i][0], points[j][i][1])
                            ctx.lineTo(point3[0], point3[1])
                        }
                        ctx.stroke()
                    }
                    ctx.restore()
                }

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0,0,canvas_background.width,canvas_background.height)
                    drawLine(ctx, root.p_task_lines)
                    drawPoint(ctx, root.p_task_points)
                    drawRegion(ctx, root.p_task_regions)
                }
            }

            Canvas {
                id: canvas_obstacles
                width: map_width * map_rate  + paint_begin_offset * 2
                height: map_height * map_rate + paint_begin_offset * 2

                x: canvas_background.x
                y: canvas_background.y
                function drawObstacles(ctx, obstacles, is_polygon) {
                    if (obstacles.length <= 0) {
                        return
                    }
                    if (is_polygon) {
                        ctx.save()
                        ctx.lineWidth = 0.5
                        ctx.strokeStyle = "#ff00ff"
                        ctx.fillStyle = "rgba(255,255,0,0.5)"
                        for (var i = 0; i < obstacles.length; ++i) {
                            ctx.beginPath()
                            var first_point = geometryToPixel(obstacles[i][0][0], obstacles[i][0][1])
                            ctx.moveTo(first_point[0], first_point[1])
                            for (var j = 0; j < obstacles[i].length; ++j) {
                                var point3 = geometryToPixel(obstacles[i][j][0], obstacles[i][j][1])
                                ctx.lineTo(point3[0], point3[1])
                            }
                            ctx.closePath()
                            ctx.stroke()
                            ctx.fill()
                        }
                        ctx.restore()
                    } else {
                        ctx.save()
                        ctx.strokeStyle = "#FFA500"
                        ctx.fillStyle = "#FFEFD5"
                        for (var i = 0; i < obstacles.length; ++i) {
                            for (var j = 0; j < obstacles[i].length; ++j) {
                                var point = geometryToPixel(obstacles[i][j][0], obstacles[i][j][1])
                                ctx.beginPath()
                                ctx.arc(point[0],point[1],0.7,0,2*Math.PI)
                                ctx.fill()
                                ctx.stroke()
                            }
                        }
                        ctx.restore()
                    }
                }

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0,0,canvas_background.width,canvas_background.height)
                    drawObstacles(ctx, root.var_obstacles, root.obstacles_is_polygon)
                }

            }

            Canvas {
                id: canvas_ref_line
                width: map_width * map_rate  + paint_begin_offset * 2
                height: map_height * map_rate + paint_begin_offset * 2
                x: canvas_background.x
                y: canvas_background.y

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0,0,canvas_background.width,canvas_background.height)
                    drawLine2d(ctx, root.var_ref_line, "#ff0000")
                }
            }

            Canvas {
                id: canvas_red_ref_line
                width: map_width * map_rate  + paint_begin_offset * 2
                height: map_height * map_rate + paint_begin_offset * 2

                x: canvas_background.x
                y: canvas_background.y

                function drawCleanGreenLine(ctx, points, color) {
                    if (points.length <= 0) {
                        return
                    }
                    ctx.save()
                    ctx.lineWidth = 1
                    ctx.strokeStyle = color
                    ctx.beginPath()
                    var first_pointt = geometryToPixel(points[0][0], points[0][1])
                    ctx.moveTo(first_pointt[0], first_pointt[1])
                    for (var i = 0; i < ref_line_curren_index; ++i) {
                        var point = geometryToPixel(points[i][0], points[i][1])
                        ctx.lineTo(point[0], point[1])
                    }
                    ctx.stroke()
                    ctx.restore()
                }
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0,0,canvas_background.width,canvas_background.height)

                    drawCleanGreenLine(ctx, root.var_ref_line, "#00ff00") //green
                }
            }

            Canvas {
                id: canvas_trajectory
                width: map_width * map_rate  + paint_begin_offset * 2
                height: map_height * map_rate + paint_begin_offset * 2

                property bool clean_all: false
                x: canvas_background.x
                y: canvas_background.y

                function drawtrajectory(ctx, points) {
                    if (points.length <= 0) {
                        return
                    }
                    ctx.save()
                    ctx.lineWidth = vehicle.height
                    ctx.strokeStyle = "#7FFFAA"
                    ctx.lineJoin="round";
                    ctx.lineCap="round";

                    ctx.beginPath()
                    var first_pointt = geometryToPixel(points[0][0], points[0][1])
                    ctx.moveTo(first_pointt[0], first_pointt[1])
                    for (var i = 0; i < points.length; ++i) {
                        var point = geometryToPixel(points[i][0], points[i][1])
                        ctx.lineTo(point[0], point[1])
                    }
                    ctx.stroke()
                    ctx.restore()
                }

                onPaint: {
                    var ctx = getContext("2d")
                    if (clean_all) {
                        ctx.clearRect(0,0,canvas_background.width,canvas_background.height)
                    }
                    drawtrajectory(ctx, root.var_trajectory);
                }
                Component.onCompleted: {
                    root.var_trajectory = ros_message_manager.getAllTrajectory()
                    canvas_trajectory.requestPaint()
                }
            }


            Canvas {
                id: canvas_planning_ref_line
                width: map_width * map_rate  + paint_begin_offset * 2
                height: map_height * map_rate + paint_begin_offset * 2

                x: canvas_background.x
                y: canvas_background.y

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0,0,canvas_background.width,canvas_background.height)
                    drawLine2d(ctx, root.var_planning_ref_path, "#FF00FF")
                    drawLine2d(ctx, root.var_planning_path, "#4169E1")
                }
            }

            Canvas {
                id: canvas_begin_points
                width: map_width * map_rate  + paint_begin_offset * 2
                height: map_height * map_rate + paint_begin_offset * 2

                x: canvas_background.x
                y: canvas_background.y

                onImageLoaded: requestPaint()
                Component.onCompleted: {
                    loadImage("qrc:/res/ui/task/qidian_no.png")
                }

                function drawBeginPoints(ctx, begin_points) {
                    if (!root.could_select_begin_point) {
                        return
                    }

                    if (begin_points.length <= 0) {
                        return
                    }
                    var num = 0;
                    for (var i = 0; i < begin_points.length; ++i) {
                        ctx.save()
                        var point = geometryToPixel(begin_points[i][0], begin_points[i][1])
                        ctx.translate(point[0],point[1]);
                        ctx.rotate(-begin_points[i][2] );

                        if(root.choosePoint[0] >= point[0] - vehicle.height &&
                                root.choosePoint[0] <= point[0] + vehicle.height  &&
                                root.choosePoint[1] >= point[1] - vehicle.height &&
                                root.choosePoint[1] <= point[1] + vehicle.height  ) {
                            ctx.drawImage("qrc:/res/ui/task/qidian_choose.png",- vehicle.height,- vehicle.height,
                                          vehicle.height * 2 ,vehicle.height * 2);
                            root.is_select_begin_point = true
                            map_task_manager.setInitPos(begin_points[i][0],begin_points[i][1],begin_points[i][2])
                            ++ num
                        } else {
                            ctx.drawImage("qrc:/res/ui/task/qidian_no.png",- vehicle.height,- vehicle.height,
                                          vehicle.height * 2 ,vehicle.height * 2);
                        }
                        if (num <= 0) {
                            root.is_select_begin_point = false
                        }

                        ctx.restore()
                    }


                }

                onPaint: {
                    var ctx=getContext("2d");
                    ctx.clearRect(0,0,canvas_background.width,canvas_background.height)
                    drawBeginPoints(ctx,root.begin_points)
                }
            }

            VehicleItem {
                id: vehicle
                visible: true
                opacity: 1
            }
        }
    }


    PinchArea{
        id:parea
        anchors.fill: parent
        pinch.maximumScale: 8
        pinch.minimumScale: 0.3
        pinch.dragAxis:Pinch.XAndYAxis
        pinch.target: map


        MouseArea {
            id: dragArea
            anchors.fill: parent
            drag.target: map
            onWheel: {
                if(wheel.angleDelta.y > 0 ){
                    map.scale += 0.2
                }else{
                    if (map.scale <= 0) {
                        return
                    }
                    map.scale -= 0.1
                }
            }
            onClicked: {
                var x = map.width / 2 - ( map.width / 2 - mouse.x + map.x) / map.scale
                var y = map.height / 2 - ( map.height / 2 - mouse.y + map.y) / map.scale
                root.choosePoint = [x, y]
//                console.info(root.pixelToGeometry(root.choosePoint[0],root.choosePoint[1]))
                canvas_begin_points.requestPaint()
            }
            onPressed: {
                root.can_drag = true
            }

            onDoubleClicked: {
                root.can_drag = false
                map.x = (map.width / 2 - vehicle.x) * (map.scale)
                map.y = (map.height / 2 - vehicle.y) * (map.scale)
                canvas_background.requestPaint()
                canvas_task.requestPaint()
                canvas_planning_ref_line.requestPaint()
                canvas_red_ref_line.requestPaint()
                canvas_obstacles.requestPaint()
            }
        }
    }

}
