#ifndef TERGEO_APP_QJSON_TRANSFORMER_H
#define TERGEO_APP_QJSON_TRANSFORMER_H

#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QVariantList>

class QJsonTransformer
{
public:
    QJsonTransformer();

    static QVariantList ParseRoads(const QJsonObject& obj);
    static QVariantList ParseSignals(const QJsonObject& obj);
    static QVariantList ParseTrees(const QJsonObject &obj);
    static QVariantList ParseStopSigns(const QJsonObject &obj);
    static QVariantList ParseSpeedBumps(const QJsonObject &obj);
    static QVariantList ParseRoadEdges(const QJsonObject &obj);
    static QVariantList ParseLaneLines(const QJsonObject &obj);
    static QVariantList ParseClearAreas(const QJsonObject &obj);
    static QVariantList ParseCrosswalks(const QJsonObject &obj);
    static QVariantList ParseJunctions(const QJsonObject &obj);
    static QVariantList ParseParkingSpaces(const QJsonObject &obj);
};

#endif // QJSON_TRANSFORMER_H
