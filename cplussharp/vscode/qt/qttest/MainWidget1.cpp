
#include "MainWidget1.h"
MainWidget1::MainWidget1(QWidget *parent) : QWidget(parent) {
  MainButton_1 = new QPushButton("MainButton_1", this);
  setFixedSize(500, 500);
  setWindowTitle("MainWindow");
  MainButton_1->setFixedSize(200, 100);
  connect(MainButton_1, &QPushButton::clicked, this, &MainWidget1::sub_Send);
  // connect(this,&MainWidget::Send_Open,&w2,&Sec_Widget::Cao_1);
}
void MainWidget1::sub_Send(void) {
  // emit Send_Open();
  MainButton_1->setText("aaaaaaaa");
}
