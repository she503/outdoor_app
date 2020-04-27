#include "qjson_transformer.h"

QJsonTransformer::QJsonTransformer()
{

}

QVariantList QJsonTransformer::ParseRoads(const QJsonObject &obj)
{
    QVariantList list;
    if (obj.contains("roads")) {
        QVariantList var_include;
        QJsonObject temp_obj = obj.value("roads").toObject();
        if (temp_obj.contains("include")) {
            QJsonObject include_obj = temp_obj.value("include").toObject();
            for (int i = 0; i < include_obj.size(); ++i) {
                QVariant pos = include_obj.value(QString::number(i));
                var_include.append(pos);
            }
            list.append(var_include);
        }
        if (temp_obj.contains("exclude")) {
            QVariantList var_exclude;
            QJsonObject exclude_obj = temp_obj.value("exclude").toObject();
            for (int i = 0; i < exclude_obj.size(); ++i) {
                QVariant pos = exclude_obj.value(QString::number(i));
                var_exclude.append(pos);
            }
            list.append(var_exclude);
        }
    }
    return list;
}

QVariantList QJsonTransformer::ParseSignals(const QJsonObject &obj)
{
    QVariantList list;
    if (obj.contains("road_signals")) {
        QJsonObject temp_obj = obj.value("road_signals").toObject();
        for (int i = 0; i < temp_obj.size(); ++i) {
            QVariant pos = temp_obj.value(QString::number(i));
            list.append(pos);
        }
    }
    return list;
}

QVariantList QJsonTransformer::ParseTrees(const QJsonObject &obj)
{
    QVariantList list;
    if (obj.contains("trees")) {
        QJsonObject temp_obj = obj.value("trees").toObject();
        for (int i = 0; i < temp_obj.size(); ++i) {
            QVariant pos = temp_obj.value(QString::number(i));
            list.append(pos);
        }
    }
    return list;
}

QVariantList QJsonTransformer::ParseStopSigns(const QJsonObject &obj)
{
    QVariantList list;
    if (obj.contains("stop_signs")) {
        QJsonObject temp_obj = obj.value("stop_signs").toObject();
        for (int i = 0; i < temp_obj.size(); ++i) {
            QVariant pos = temp_obj.value(QString::number(i));
            list.append(pos);
        }
    }
    return list;
}

QVariantList QJsonTransformer::ParseSpeedBumps(const QJsonObject &obj)
{
    QVariantList list;
    if (obj.contains("speed_bumps")) {
        QJsonObject temp_obj = obj.value("speed_bumps").toObject();
        for (int i = 0; i < temp_obj.size(); ++i) {
            QVariant pos = temp_obj.value(QString::number(i));
            list.append(pos);
        }
    }
    return list;
}

QVariantList QJsonTransformer::ParseRoadEdges(const QJsonObject &obj)
{
    QVariantList list;
    if (obj.contains("road_edges")) {
        QJsonObject temp_obj = obj.value("road_edges").toObject();
        for (int i = 0; i < temp_obj.size(); ++i) {
            QJsonObject pos_obj = temp_obj.value(QString::number(i)).toObject();
            QJsonArray temp_arr;
            temp_arr.append(pos_obj.value("pos"));
            temp_arr.append(pos_obj.value("type"));
            QVariant pos = temp_arr;
            list.append(pos);
        }
    }
    return list;
}

QVariantList QJsonTransformer::ParseLaneLines(const QJsonObject &obj)
{
    QVariantList list;
    if (obj.contains("lane_lines")) {
        QJsonObject temp_obj = obj.value("lane_lines").toObject();
        for (int i = 0; i < temp_obj.size(); ++i) {
            QJsonObject pos_obj = temp_obj.value(QString::number(i)).toObject();
            QJsonArray temp_arr;
            temp_arr.append(pos_obj.value("pos"));
            temp_arr.append(pos_obj.value("type"));
            QVariant pos = temp_arr;
            list.append(pos);
        }
    }
    return list;
}

QVariantList QJsonTransformer::ParseClearAreas(const QJsonObject &obj)
{
    QVariantList list;
    if (obj.contains("clear_areas")) {
        QVariantList var_include;
        QJsonObject temp_obj = obj.value("clear_areas").toObject();

        if (temp_obj.contains("include")) {
            QJsonObject include_obj = temp_obj.value("include").toObject();
            for (int i = 0; i < include_obj.size(); ++i) {
                QVariant pos = include_obj.value(QString::number(i));
                var_include.append(pos);
            }
            list.append(var_include);
        } else if (temp_obj.contains("exclude")) {
            QVariantList var_exclude;
            QJsonObject exclude_obj = temp_obj.value("exclude").toObject();
            for (int i = 0; i < exclude_obj.size(); ++i) {
                QVariant pos = exclude_obj.value(QString::number(i));
                var_exclude.append(pos);
            }
            list.append(var_exclude);
        }


    }
    return list;
}

QVariantList QJsonTransformer::ParseCrosswalks(const QJsonObject &obj)
{
    QVariantList list;
    if (obj.contains("crosswalks")) {
        QVariantList var_include;
        QJsonObject temp_obj = obj.value("crosswalks").toObject();
        if (temp_obj.contains("include")) {
            QJsonObject include_obj = temp_obj.value("include").toObject();
            for (int i = 0; i < include_obj.size(); ++i) {
                QVariant pos = include_obj.value(QString::number(i));
                var_include.append(pos);
            }
            list.append(var_include);
        } else if (temp_obj.contains("exclude")) {
            QVariantList var_exclude;
            QJsonObject exclude_obj = temp_obj.value("exclude").toObject();
            for (int i = 0; i < exclude_obj.size(); ++i) {
                QVariant pos = exclude_obj.value(QString::number(i));
                var_exclude.append(pos);
            }
            list.append(var_exclude);
        }
    }
    return list;
}

QVariantList QJsonTransformer::ParseJunctions(const QJsonObject &obj)
{
    QVariantList list;
    if (obj.contains("junctions")) {
        QVariantList var_include;
        QJsonObject temp_obj = obj.value("junctions").toObject();
        if (temp_obj.contains("include")) {
            QJsonObject include_obj = temp_obj.value("include").toObject();
            for (int i = 0; i < include_obj.size(); ++i) {
                QVariant pos = include_obj.value(QString::number(i));
                var_include.append(pos);
            }
            list.append(var_include);
        } else if (temp_obj.contains("exclude")) {
            QVariantList var_exclude;
            QJsonObject exclude_obj = temp_obj.value("exclude").toObject();
            for (int i = 0; i < exclude_obj.size(); ++i) {
                QVariant pos = exclude_obj.value(QString::number(i));
                var_exclude.append(pos);
            }
            list.append(var_exclude);
        }
    }
    return list;
}

QVariantList QJsonTransformer::ParseParkingSpaces(const QJsonObject &obj)
{
    QVariantList list;
    if (obj.contains("parking_spaces")) {
        QVariantList var_include;
        QJsonObject temp_obj = obj.value("parking_spaces").toObject();
        if (temp_obj.contains("include")) {
            QJsonObject include_obj = temp_obj.value("include").toObject();
            for (int i = 0; i < include_obj.size(); ++i) {
                QVariant pos = include_obj.value(QString::number(i));
                var_include.append(pos);
            }
            list.append(var_include);
        } else if (temp_obj.contains("exclude")) {
            QVariantList var_exclude;
            QJsonObject exclude_obj = temp_obj.value("exclude").toObject();
            for (int i = 0; i < exclude_obj.size(); ++i) {
                QVariant pos = exclude_obj.value(QString::number(i));
                var_exclude.append(pos);
            }
            list.append(var_exclude);
        }
    }
    return list;
}
