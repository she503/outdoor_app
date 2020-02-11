#include "file_io.h"
#include <QJsonParseError>
#include <QDebug>
FileIO::FileIO(QObject *parent) : QObject(parent),  _magic_num(0), _file_size(0)
{

}

FileIO::FileIO(const QString &path) : _magic_num(0), _file_size(0)
{
    _path = path;
}

bool FileIO::writeData(QJsonObject json_doc)
{
    QJsonDocument doc(json_doc);
    if (_path != nullptr) {
        QFile file(_path);
        if (file.open(QIODevice::WriteOnly)) {

            QDataStream stream(&file);
            stream << (quint32)0x00000011;
            stream << (quint32)doc.toBinaryData().size();
            stream << doc.toJson();
            stream.setVersion(QDataStream::Qt_5_9);
            file.close();
            qInfo() << "[FileIO::writeData]: write success";
            return true;
        } else {
            qCritical() << "[FileIO::writeData]: write error";
        }
    }
    return false;
}

QJsonDocument FileIO::readData()
{
    QFile file(_path);
    if (file.open(QIODevice::ReadOnly)) {
        QDataStream stream(&file);
        stream.setVersion(QDataStream::Qt_5_9);

        stream >> _magic_num;
        if (_magic_num == 0x00000011) {
            QByteArray byte;
            stream >> _file_size;
            stream >> byte;
            QJsonParseError error;
            QJsonDocument document=QJsonDocument::fromJson(byte, &error);

            if (error.error == QJsonParseError::NoError) {
//                qInfo() << "[FileIO::readData]: read and parse success!";
                return document;
            } else {
                qCritical() << "[FileIO::readData]: js error ->" << error.errorString();
            }
        }
    } else {
        qCritical() << "[FileIO::readData]: error ->" << file.errorString();
    }
}

void FileIO::setFilePath(const QString &path)
{
    _path = path;
}

quint32 FileIO::getMagicNum()
{
    return _magic_num;
}

quint32 FileIO::getFileSize()
{
    return _file_size;
}
