/****************************************************************************
** Meta object code from reading C++ file 'user_account_manage.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.9.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "user_account_manage.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'user_account_manage.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.9.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_UserAccountManage_t {
    QByteArrayData data[6];
    char stringdata0[73];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_UserAccountManage_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_UserAccountManage_t qt_meta_stringdata_UserAccountManage = {
    {
QT_MOC_LITERAL(0, 0, 17), // "UserAccountManage"
QT_MOC_LITERAL(1, 18, 18), // "emitALLUserAccount"
QT_MOC_LITERAL(2, 37, 0), // ""
QT_MOC_LITERAL(3, 38, 5), // "nomal"
QT_MOC_LITERAL(4, 44, 5), // "admin"
QT_MOC_LITERAL(5, 50, 22) // "readAllUserAccountData"

    },
    "UserAccountManage\0emitALLUserAccount\0"
    "\0nomal\0admin\0readAllUserAccountData"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_UserAccountManage[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       2,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    2,   24,    2, 0x06 /* Public */,

 // methods: name, argc, parameters, tag, flags
       5,    0,   29,    2, 0x02 /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::QJsonObject, QMetaType::QJsonObject,    3,    4,

 // methods: parameters
    QMetaType::Bool,

       0        // eod
};

void UserAccountManage::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        UserAccountManage *_t = static_cast<UserAccountManage *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->emitALLUserAccount((*reinterpret_cast< const QJsonObject(*)>(_a[1])),(*reinterpret_cast< const QJsonObject(*)>(_a[2]))); break;
        case 1: { bool _r = _t->readAllUserAccountData();
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (UserAccountManage::*_t)(const QJsonObject & , const QJsonObject & );
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&UserAccountManage::emitALLUserAccount)) {
                *result = 0;
                return;
            }
        }
    }
}

const QMetaObject UserAccountManage::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_UserAccountManage.data,
      qt_meta_data_UserAccountManage,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *UserAccountManage::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *UserAccountManage::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_UserAccountManage.stringdata0))
        return static_cast<void*>(const_cast< UserAccountManage*>(this));
    return QObject::qt_metacast(_clname);
}

int UserAccountManage::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 2)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 2;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 2)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 2;
    }
    return _id;
}

// SIGNAL 0
void UserAccountManage::emitALLUserAccount(const QJsonObject & _t1, const QJsonObject & _t2)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
