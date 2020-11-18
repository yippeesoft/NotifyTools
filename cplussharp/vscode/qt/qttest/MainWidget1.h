

#include <QPushButton>
#include <QWidget>
class MainWidget1 : public QWidget {
  Q_OBJECT
public:
  explicit MainWidget1(QWidget *parent = nullptr);
  void sub_Send(void);

private:
  QPushButton *MainButton_1;
signals:

  void Send_Open(void);
public slots:
};