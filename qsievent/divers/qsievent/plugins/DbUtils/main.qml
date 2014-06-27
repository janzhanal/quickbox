import QtQml 2.0
import qf.core 1.0
import qf.qmlwidgets 1.0
import qf.qmlwidgets.framework 1.0

Plugin {
	id: root
	property var dbSchema: DbSchema {}
	featureId: 'DbUtils'
	//dependsOnFeatureIds: "Core"
	property var dlgConnectDb: Component {
		DlgConnectDb {}
	}

	actions: [
		Action {
			id: actConnectDb
			text: qsTr('&Connect to databse')
			//shortcut: "Ctrl+E"
			onTriggered: {
				Log.info(text, "triggered");
				connectToSqlServer(false);
			}
		},
		Action {
			id: actCreateEvent
			text: qsTr('Create new event')
			onTriggered: {
				Log.info(text, "triggered");
			}
		},
		Action {
			id: actOpenEvent
			text: qsTr('&Open event')
			shortcut: "Ctrl+O"
			onTriggered: {
				Log.info(text, "triggered");
			}
		},
		Action {
			id: actQuit
			text: qsTr('&Quit')
			onTriggered: {
				Log.info(text, "triggered");
				Qt.quit();
			}
		}
	]

	function install()
	{
		//_Plugin_install();
		FrameWork.menuBar.itemForPath('file').addAction(actConnectDb);
		FrameWork.menuBar.itemForPath('file').addSeparator();
		FrameWork.menuBar.itemForPath('file').addAction(actCreateEvent);
		FrameWork.menuBar.itemForPath('file').addSeparator();
		FrameWork.menuBar.itemForPath('file').addAction(actQuit);
		//framework.addMenu('tools', actCreateEvent);
		/*
		var c = Qt.createComponent("DbSchema.qml");
		if (c.status == Component.Ready) {
			root.dbSchema = c.createObject(root);
		}
		else {
			Log.error("Error creating DbSchema:", c.errorString());
		}
		Log.info(dbSchema);
		*/
	}

	function connectToSqlServer(silent)
	{
		var cancelled = false;
		if(!silent) {
			var dlg = dlgConnectDb.createObject(FrameWork);
			cancelled = !dlg.exec();
			dlg.destroy();
		}
		if(!cancelled) {
			var core_feature = FrameWork.plugin("Core");
			var db = Sql.database();
			var settings = core_feature.settings();
			settings.beginGroup("sql/connection");
			db.hostName = settings.value('host');
			db.userName = settings.value('user');
			db.password = core_feature.crypt.decrypt(settings.value("password", ""));
			db.databaseName = 'quickevent';
			db.open();
			db.destroy();
			settings.destroy();
		}
	}
}
