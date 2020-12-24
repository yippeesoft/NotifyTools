
#include "MainWidget1.h"
#include <QtGui>

MainWidget1::MainWidget1(QWidget* parent)
    : QWidget(parent)
{
    MainButton_1 = new QPushButton("MainButton_1", this);
    setFixedSize(500, 500);
    setWindowTitle("MainWindow");
    MainButton_1->setFixedSize(200, 100);
    connect(MainButton_1, &QPushButton::clicked, this, &MainWidget1::sub_Send);

    setWindowIcon(QIcon("/home/sf/pose.jpg"));
    setWindowTitle("sss");

    this->setAutoFillBackground(true);
    QPixmap pixmap;
    bool bb = pixmap.load("./pose.jpg"); //设定图片
    Q_ASSERT(bb == true);
    QPalette palette = this->palette();                       //创建一个调色板对象
    palette.setBrush(this->backgroundRole(), QBrush(pixmap)); //用调色板的画笔把映射到pixmap上的图片画到frame.backgroundRole()这个背景上
    this->setPalette(palette);
}
void MainWidget1::sub_Send(void)
{
    // emit Send_Open();
    MainButton_1->setText("aaaaa中文 中文aassa");
}

void MainWidget1::paintEvent(QPaintEvent* p)

{
#if 0
    QPixmap pixmap;
    bool bb = pixmap.load("./pose.jpg"); //设定图片
    Q_ASSERT(bb == true);
    // QPalette palette = this->palette();                       //创建一个调色板对象
    // palette.setBrush(this->backgroundRole(), QBrush(pixmap)); //用调色板的画笔把映射到pixmap上的图片画到frame.backgroundRole()这个背景上
    // connect(this,&MainWidget::Send_Open,&w2,&Sec_Widget::Cao_1);
    QPainter painter(this);

    painter.drawPixmap(0, 0, 500, 500, pixmap);

    painter.setPen(QPen(Qt::blue, 2, Qt::SolidLine, Qt::RoundCap));
    painter.drawLine(0, 28, this->width(), 28);
    painter.drawLine(1006, 28, 1006, this->height());
#endif
}