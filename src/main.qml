import QtQuick 2.9
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.0


ApplicationWindow {
    title: "Hello World"
    width: 1024
    height: 768
    color: "white"
    visible: true
    Rectangle {
        id: root
        width: 1024
        height: 768
        anchors.fill: parent

        property color col: "lightsteelblue"
        gradient: Gradient {
            GradientStop {
                position: 0.0; color: Qt.tint(root.col, "#20FFFFFF")
            }
            GradientStop {
                position: 0.1; color: Qt.tint(root.col, "#20AAAAAA")
            }
            GradientStop {
                position: 0.9; color: Qt.tint(root.col, "#20666666")
            }
            GradientStop {
                position: 1.0; color: Qt.tint(root.col, "#20000000")
            }
        }

        property int mode: 0
        property bool showResizers: true
        property bool fill: false

        Row {
            x: 20
            y: 10
            spacing: 20
            Rectangle {
                border.color: "black"
                color: root.mode === 0 ? "red": "transparent"
                width: 100
                height: 40
                Text {
                    anchors.centerIn: parent
                    text: "Line"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.mode = 0
                }
            }
            Rectangle {
                border.color: "black"
                color: root.mode === 1 ? "red": "transparent"
                width: 100
                height: 40
                Text {
                    anchors.centerIn: parent
                    text: "Cubic"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.mode = 1
                }
            }
            Rectangle {
                border.color: "black"
                color: root.mode === 2 ? "red": "transparent"
                width: 100
                height: 40
                Text {
                    anchors.centerIn: parent
                    text: "Quadratic"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.mode = 2
                }
            }

            Slider {
                id: widthSlider
                // name: "Width"
                from: 1
                to: 60
                // position: 4
            }

            Rectangle {
                border.color: "black"
                color: root.showResizers ? "yellow": "transparent"
                width: 50
                height: 40
                Text {
                    anchors.centerIn: parent
                    text: "Manip"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.showResizers = !root.showResizers;
                        for (var i = 0; i < canvas.resizers.length; ++i)
                        canvas.resizers[i].visible = root.showResizers;
                        }
                    }
                }

                Rectangle {
                    border.color: "black"
                    color: root.fill ? "yellow": "transparent"
                    width: 50
                    height: 40
                    Text {
                        anchors.centerIn: parent
                        text: "Fill"
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.fill = !root.fill
                    }
                }
            }

            Rectangle {
                id: canvas
                width: root.width - 40
                height: root.height - 120
                x: 20
                y: 100

                property variant activePath: null

                property variant resizers: []
                property variant funcs

                function genResizer(obj, x, y, xprop, yprop, color)
                {
                    var ma = Qt.createQmlObject('import QtQuick 2.9; import QtQuick.Shapes 1.0; Rectangle { id: rr; property variant obj; color: "' + color + '"; width: 20; height: 20;'+
                    'MouseArea { anchors.fill: parent; hoverEnabled: true;' +
                    'onEntered: color = "yellow"; onExited: color = "' + color + '";' +
                    'property bool a: false; onPressed: a = true; onReleased: a = false; ' +
                    'onPositionChanged: if (a) { var pt = mapToItem(rr.parent, mouse.x, mouse.y);' +
                    'obj.' + xprop + ' = pt.x; obj.' + yprop + ' = pt.y; rr.x = pt.x - 10; rr.y = pt.y - 10; } } }',
                    canvas, "resizer_item");
                    ma.visible = root.showResizers;
                    ma.obj = obj;
                    ma.x = x - 10;
                    ma.y = y - 10;
                    resizers.push(ma);
                    return ma;
                }

                Component.onCompleted: {
                    funcs = [
                { "start": function(x, y) {
                    var p = Qt.createQmlObject('import QtQuick 2.9; import QtQuick.Shapes 1.0; ShapePath {' +
                    'strokeColor: "black"; fillColor: "transparent";'+
                    'strokeWidth: ' + widthSlider.value + ';' +
                    'startX: ' + x + '; startY: ' + y + ';' +
                    'PathLine { x: ' + x + ' + 1; y: ' + y + ' + 1 } }',
                    root, "dynamic_visual_path");
                    shape.data.push(p);
                    activePath = p;
                }, "move": function(x, y) {
                if (!activePath)
                return;
                var pathObj = activePath.pathElements[0];
                pathObj.x = x;
                pathObj.y = y;
            }, "end": function() {
            canvas.genResizer(activePath, activePath.startX, activePath.startY, "startX", "startY", "red");
            var pathObj = activePath.pathElements[0];
            canvas.genResizer(pathObj, pathObj.x, pathObj.y, "x", "y", "red");
            activePath = null;
        }
    },
{ "start": function(x, y) {
    var p = Qt.createQmlObject('import QtQuick 2.9; import QtQuick.Shapes 1.0; ShapePath {' +
    'strokeColor: "black"; fillColor: "' + (root.fill ? 'green': 'transparent') + '";'+
    'strokeWidth: ' + widthSlider.value + ';' +
    'startX: ' + x + '; startY: ' + y + ';' +
    'PathCubic { x: ' + x + ' + 1; y: ' + y + ' + 1;' +
    'control1X: ' + x + ' + 50; control1Y: ' + y + ' + 50; control2X: ' + x + ' + 150; control2Y: ' + y + ' + 50; } }',
    root, "dynamic_visual_path");
    shape.data.push(p);
    activePath = p;
}, "move": function(x, y) {
if (!activePath)
return;
var pathObj = activePath.pathElements[0];
pathObj.x = x;
pathObj.y = y;
}, "end": function() {
canvas.genResizer(activePath, activePath.startX, activePath.startY, "startX", "startY", "red");
var pathObj = activePath.pathElements[0];
canvas.genResizer(pathObj, pathObj.x, pathObj.y, "x", "y", "red");
canvas.genResizer(pathObj, pathObj.control1X, pathObj.control1Y, "control1X", "control1Y", "blue");
canvas.genResizer(pathObj, pathObj.control2X, pathObj.control2Y, "control2X", "control2Y", "lightBlue");
activePath = null;
}
},
{ "start": function(x, y) {
var p = Qt.createQmlObject('import QtQuick 2.9; import QtQuick.Shapes 1.0; ShapePath {' +
'strokeColor: "black"; fillColor: "' + (root.fill ? 'green': 'transparent') + '";'+
'strokeWidth: ' + widthSlider.value + ';' +
'startX: ' + x + '; startY: ' + y + ';' +
'PathQuad { x: ' + x + ' + 1; y: ' + y + ' + 1;' +
'controlX: ' + x + ' + 50; controlY: ' + y + ' + 50 } }',
root, "dynamic_visual_path");
shape.data.push(p);
activePath = p;
}, "move": function(x, y) {
if (!activePath)
return;
var pathObj = activePath.pathElements[0];
pathObj.x = x;
pathObj.y = y;
}, "end": function() {
canvas.genResizer(activePath, activePath.startX, activePath.startY, "startX", "startY", "red");
var pathObj = activePath.pathElements[0];
canvas.genResizer(pathObj, pathObj.x, pathObj.y, "x", "y", "red");
canvas.genResizer(pathObj, pathObj.controlX, pathObj.controlY, "controlX", "controlY", "blue");
activePath = null;
}
}
];
}

MouseArea {
    anchors.fill: parent
    onPressed: {
        canvas.funcs[root.mode].start(mouse.x, mouse.y);
        }
        onPositionChanged: {
            canvas.funcs[root.mode].move(mouse.x, mouse.y);
            }
            onReleased: {
                canvas.funcs[root.mode].end();
                }
            }

            Shape {
                id: shape
                anchors.fill: parent

                data: []
            }
        }
    }
}
