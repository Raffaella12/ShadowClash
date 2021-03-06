//
//  configmanager.cpp
//  ShadowClash
//
//  Created by TheWanderingCoel on 2018/6/12.
//  Copyright © 2019 Coel Wu. All rights reserved.
//

#include "apirequest.h"
#include "configmanager.h"
#include "notificationcenter.h"
#include "paths.h"

#include <QApplication>
#include <QDir>
#include <QDebug>
#include <QFileInfoList>
#include <QFileSystemWatcher>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <QLocale>
#include <QMessageBox>
#include <QSettings>
#include <QString>

const QString ConfigManager::version = QString("0.0.1");

QString ConfigManager::apiPort = QString("9090");

QString ConfigManager::apiSecret;

QString ConfigManager::apiUrl = QString("http://127.0.0.1:") + apiPort;

const QDate ConfigManager::buildDate = QLocale(QLocale::English).toDate(QString(__DATE__).replace("  ", " 0"), "MMM dd yyyy");

const QTime ConfigManager::buildTime = QTime::fromString(__TIME__, "hh:mm:ss");

bool ConfigManager::startAtLogin;

QString ConfigManager::selectConfigName = QString("config");

bool ConfigManager::proxyPortAutoSet;

bool ConfigManager::enhanceMode;

bool ConfigManager::buildInApiMode = true;

QString ConfigManager::selectDashBoard = QString("clashxdashboard");

QString ConfigManager::benchMarkUrl = QString("http://www.gstatic.com/generate_204");

int ConfigManager::windowNumber = 1;

void ConfigManager::watchConfigFile(QString configName)
{
    ConfigManager *cm = new ConfigManager();
    QFileSystemWatcher *watcher = new QFileSystemWatcher();
    QString path = Paths::configFolderPath + configName + ".yaml";
    connect(watcher, SIGNAL(fileChanged(const QString &)), cm, SLOT(fileChanged()));
}

void ConfigManager::copySampleConfigIfNeed()
{
    if (!QFile::exists(Paths::defaultConfigFilePath)) {
        QFile::copy(":/sampleConfig.yaml", Paths::defaultConfigFilePath);
    }
}

void ConfigManager::fileChanged()
{
    NotificationCenter::postConfigFileChangeDetectionNotice();
}

void ConfigManager::checkFinalRuleAndShowAlert()
{
    QJsonObject obj = ApiRequest::getRules();
    QJsonArray array = obj["rules"].toArray();
    bool hasFinalRule = false;

    for (int i=0; i<array.size(); i++) {
        QJsonObject each = array[i].toObject();
        QString value = each.value("type").toString();
        if (value.toUpper() == "MATCH") {
            hasFinalRule = true;
            break;
        } else {
            continue;
        }
    }

    if (!hasFinalRule) {
        showNoFinalRuleAlert();
    }
}

void ConfigManager::showNoFinalRuleAlert()
{
    QMessageBox alert;
    alert.setWindowTitle("ShadowClash");
    alert.setText(tr("No FINAL rule were found in clash configs,This might caused by incorrect upgradation during earily version of ShadowClash or error setting of FINAL rule.Please check your config file.\n\nNO FINAL rule would cause traffic send to DIRECT which no match any rules."));
    alert.addButton(tr("OK"), QMessageBox::YesRole);
    alert.exec();
}

QStringList ConfigManager::getConfigFilesList()
{
    QStringList result;
    QDir dir(Paths::configFolderPath);
    QFileInfoList list = dir.entryInfoList();
    for (int i=0;i<list.size();++i) {
        QFileInfo fileInfo = list.at(i);
        if (fileInfo.suffix() == "yaml") {
            QString fileName = fileInfo.fileName().replace(".yaml","");
            result.append(fileName);
        }
    }
    return result;
}
