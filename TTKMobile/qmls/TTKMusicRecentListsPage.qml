/* =================================================
 * This file is part of the TTK Music Player project
 * Copyright (c) 2014 - 2016 Greedysky Studio
 * All rights reserved!
 * Redistribution and use of the source code or any derivative
 * works are strictly forbiden.
   =================================================*/

import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import "Core"

Item {
    id: ttkMusicRecentListsPage
    width: parent.width
    height: parent.height

    Component.onCompleted: {
        playlistModel.clear();
        var names = TTK_APP.mediaNames(ttkTheme.music_recent_list);
        var artists = TTK_APP.mediaArtists(ttkTheme.music_recent_list);
        for(var i=0; i<names.length; ++i) {
            var info = {
                title: names[i],
                artist: artists[i]
            }
            playlistModel.append(info);
        }
        itemListView.currentIndex = TTK_APP.getCurrentIndex();
    }

    Connections {
        target: TTK_APP
        onCurrentIndexChanged: {
            itemListView.currentIndex = TTK_APP.getCurrentIndex();
        }
    }

    TTKMusicSongSettingPage {
        id: ttkMusicSongSettingPage
    }

    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        ///top bar
        Rectangle {
            id: mainMenubar
            Layout.fillWidth: true
            height: dpHeight(ttkTheme.topbar_height)
            color: ttkTheme.topbar_background

            RowLayout {
                spacing: 2
                anchors.fill: parent

                TTKImageButton {
                    source: "qrc:/image/title_bar_back"
                    Layout.preferredWidth: dpWidth(50)
                    Layout.preferredHeight: dpHeight(50)
                    anchors.left: parent.left
                    onPressed: {
                        ttkMainStackView.pop();
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: ttkTheme.white
                    horizontalAlignment: Qt.AlignHCenter
                    verticalAlignment: Qt.AlignVCenter
                    font.pixelSize: mainMenubar.height/2
                    text: qsTr("最近播放")
                }

                TTKImageButton {
                    source: "qrc:/image/more_icon_settings_white"
                    Layout.preferredWidth: dpWidth(50)
                    Layout.preferredHeight: dpHeight(50)
                    anchors.right: parent.right
                }
            }
        }

        ///main body
        Rectangle {
            width: ttkMainWindow.width
            height: ttkMainStackView.height - mainMenubar.height
            color: ttkTheme.white

            ListView {
                id: itemListView
                anchors.fill: parent
                clip: true

                delegate: Component {
                    Rectangle {
                        id: wrapper
                        width: ttkMainWindow.width
                        height: dpHeight(70)
                        color: ttkTheme.white

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                itemListView.currentIndex = index;
                                TTK_APP.setCurrentIndex(ttkTheme.music_recent_list, index);
                            }
                        }

                        Rectangle {
                            width: ttkMainWindow.width
                            height: 1
                            color: ttkTheme.alphaLv9
                        }

                        Rectangle {
                            width: dpWidth(5)
                            height: parent.height*2/3
                            anchors {
                                top: parent.top
                                topMargin: parent.height/3/2
                            }
                            color: parent.ListView.isCurrentItem ? ttkTheme.topbar_background : ttkTheme.white
                        }

                        Text {
                            id: titleArea
                            text: title
                            width: ttkMusicRecentListsPage.width - iconArea.width - dpHeight(60)
                            anchors {
                                top: parent.top
                                topMargin: dpHeight(10)
                                left: parent.left
                                leftMargin: dpHeight(20)
                            }
                            elide: Text.ElideRight
                            verticalAlignment: Qt.AlignVCenter
                            font.pixelSize: parent.height*3/10
                        }

                        Image {
                            id: iconArea
                            width: parent.height/3
                            height: parent.height/3
                            anchors {
                                top: titleArea.bottom
                                topMargin: dpHeight(5)
                                left: parent.left
                                leftMargin: dpHeight(20)
                            }
                            source: "qrc:/image/ic_playlist_normal"
                        }

                        TTKImageButton {
                            id: moreFuncArea
                            width: parent.height/2
                            height: parent.height/2
                            anchors {
                                top: parent.top
                                right: parent.right
                                topMargin: dpHeight(20)
                                rightMargin: dpHeight(20)
                            }
                            source: "qrc:/image/ic_playlist_more_normal"
                            onPressed: {
                                ttkMusicSongSettingPage.songName = title;
                                ttkMusicSongSettingPage.singerName = artist;
                                ttkMusicSongSettingPage.filePath = TTK_APP.mediaPath(ttkTheme.music_recent_list, index);
                                ttkMusicSongSettingPage.visible = true;
                            }
                        }

                        Text {
                            id: artistArea
                            text: artist
                            width: titleArea.width - iconArea.width
                            anchors {
                                top: titleArea.bottom
                                topMargin: dpHeight(10)
                                left: iconArea.right
                                leftMargin: dpHeight(10)
                            }
                            elide: Text.ElideRight
                            verticalAlignment: Qt.AlignVCenter
                            font.pixelSize: parent.height/4
                            color: ttkTheme.gray
                        }
                    }
                }

                model: ListModel {
                    id: playlistModel
                }
            }
        }
    }
}