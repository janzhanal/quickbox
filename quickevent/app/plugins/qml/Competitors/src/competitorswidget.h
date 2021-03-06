#ifndef COMPETITORSWIDGET_H
#define COMPETITORSWIDGET_H

#include <QFrame>

class QCheckBox;

namespace Ui {
class CompetitorsWidget;
}
namespace qf {
namespace core {
namespace model {
class SqlTableModel;
}
}
namespace qmlwidgets {
class ForeignKeyComboBox;
}
}

class ThisPartWidget;

class CompetitorsWidget : public QFrame
{
	Q_OBJECT
private:
	typedef QFrame Super;
public:
	explicit CompetitorsWidget(QWidget *parent = 0);
	~CompetitorsWidget() Q_DECL_OVERRIDE;

	void settleDownInPartWidget(ThisPartWidget *part_widget);
private:
	Q_SLOT void lazyInit();
	Q_SLOT void reset();
	Q_SLOT void reload();

	void editCompetitor(const QVariant &id, int mode) {editCompetitor_helper(id, mode, 0);}
	void editCompetitors(int mode);

	void editCompetitor_helper(const QVariant &id, int mode, int siid);

	void onDbEventNotify(const QString &domain, int connection_id, const QVariant &data);
	void editCompetitorOnPunch(int siid);
private:
	Ui::CompetitorsWidget *ui;
	qf::core::model::SqlTableModel *m_competitorsModel;
	qf::qmlwidgets::ForeignKeyComboBox *m_cbxClasses = nullptr;
	QCheckBox *m_cbxEditCompetitorOnPunch = nullptr;
};

#endif // COMPETITORSWIDGET_H
