#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>
#include <QFile>
#include <QJsonObject>
#include <QDataStream>
#include <QJsonDocument>
#include <QIODevice>
#include <QJsonParseError>

class FileIO : public QObject
{
    Q_OBJECT
public:
    explicit FileIO(QObject *parent = nullptr);
    FileIO(const QString& path);

    bool writeData(QJsonObject json_doc);
    QJsonDocument readData();
    void setFilePath(const QString& path);
    quint32 getMagicNum();
    quint32 getFileSize();

private:
    QString _path;
    quint32 _magic_num;
    quint32 _file_size;

signals:

public slots:
};


#endif // FILEIO_H
