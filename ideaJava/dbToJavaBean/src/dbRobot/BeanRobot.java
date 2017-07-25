package dbRobot;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.*;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;

import javax.swing.DefaultCellEditor;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableColumnModel;

public class BeanRobot extends JFrame {
    private static final long serialVersionUID = 1L;
    private JTextField ipFiled;
    private JTextField dbFiled;
    //	private JTextField dbNameFiled;
    private JTextField tabField;
    private JTextField packField;
    private JTextField catField;
    private JCheckBox checkBox;
    //	private JTextField userField;
//	private JTextField pwdField;
    private JComboBox dbBox;
//    DbUtil dbutil = new DbUtil();
//    BeanUtil butil = new BeanUtil();
    JLabel labelInfo;
    private JTable jtable;
    private MyTableModel tableModel;
    //    HashMap dbInfoMap;
    String[] titles = {"选择", "表格名称"};

    //配置文件信息
    Map<String, HashMap<String, String>> dbMap;

    public BeanRobot() {

        setTitle("数据库生成javabean小工具");
        setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
        setBounds(100, 100, 544, 374);

        JPanel panel = new JPanel();
        getContentPane().add(panel, BorderLayout.CENTER);
        panel.setLayout(null);

        JLabel lblIp = new JLabel("SQLITE:");
        lblIp.setBounds(110, 13, 30, 15);
        panel.add(lblIp);

        ipFiled = new JTextField();
        ipFiled.setText("d:\\sqlite3.db");
        ipFiled.setBounds(146, 10, 147, 21);
        panel.add(ipFiled);
        ipFiled.setColumns(10);

        JLabel label = new JLabel("数据库:");
        label.setBounds(80, 41, 54, 15);
        panel.add(label);

//		String dbStyles[] = { };
//		dbBox = new JComboBox(dbStyles);
        dbBox = new JComboBox();
        dbBox.setBounds(146, 39, 147, 21);
        dbBox.setVisible(true);
        dbBox.setMaximumRowCount(3);
        dbBox.addItem("SQLITE3");
        panel.add(dbBox);

//		JLabel dbNamelabel = new JLabel("数据库名:");
//		dbNamelabel.setBounds(70, 67, 60, 20);
//		panel.add(dbNamelabel);
//
//		dbNameFiled = new JTextField();
//		dbNameFiled.setBounds(146, 68, 147, 21);
//		dbNameFiled.setText("test");
//		panel.add(dbNameFiled);
//		dbNameFiled.setColumns(10);
//
//		JLabel userLabel = new JLabel("用户名:");
//		userLabel.setBounds(80, 98, 54, 15);
//		panel.add(userLabel);
//
//		userField = new JTextField();
//		userField.setText("root");
//		userField.setBounds(145, 97, 148, 21);
//		panel.add(userField);
//		userField.setColumns(10);
//
//		JLabel pwdLabel = new JLabel("密码:");
//		pwdLabel.setBounds(95, 129, 54, 15);
//		panel.add(pwdLabel);
//
//		pwdField = new JTextField();
//		pwdField.setText("root");
//		pwdField.setBounds(145, 126, 147, 21);
//		panel.add(pwdField);
//		pwdField.setColumns(10);

        JLabel packLabel = new JLabel("包名:");
        packLabel.setBounds(95, 160, 54, 15);
        panel.add(packLabel);

        packField = new JTextField();
        packField.setText("");
        packField.setBounds(146, 155, 147, 21);
        panel.add(packField);
        packField.setColumns(10);

        JLabel catlogLabel = new JLabel("输出目录：");
        catlogLabel.setBounds(70, 193, 65, 15);
        panel.add(catlogLabel);

        catField = new JTextField();
        catField.setBounds(146, 190, 147, 21);
        panel.add(catField);
        catField.setColumns(10);

        checkBox = new JCheckBox("生成包结构目录");
        checkBox.setSelected(true);
        checkBox.setBounds(145, 220, 147, 23);
        panel.add(checkBox);


        JLabel mustdbLabel = new JLabel("* 选择数据库");
        mustdbLabel.setForeground(Color.RED);
        mustdbLabel.setBounds(303, 39, 176, 15);
        panel.add(mustdbLabel);
//		JLabel mustIPLabel = new JLabel("* IP地址及端口号");
//		mustIPLabel.setForeground(Color.RED);
//		mustIPLabel.setBounds(303, 13, 176, 15);
//		panel.add(mustIPLabel);

        JLabel mustPacklabel = new JLabel("* 包结构");
        mustPacklabel.setForeground(Color.RED);
        mustPacklabel.setBounds(303, 155, 79, 15);
        panel.add(mustPacklabel);

        JLabel catlabel = new JLabel("默认D:// ；注意格式");
        catlabel.setForeground(Color.RED);
        catlabel.setBounds(303, 193, 179, 15);
        panel.add(catlabel);


        JButton button = new JButton("查询");
        // 按钮增加动作执行go()方法
        button.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                go();

            }
        });
        button.setBounds(145, 267, 93, 23);
        panel.add(button);

        JButton crButton = new JButton("生成Bean");
        // 按钮增加动作执行go()方法
        crButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                createBean();

            }
        });
        crButton.setBounds(280, 267, 93, 23);
        panel.add(crButton);


        // 增加关闭事件监听，关闭相关操作
        this.addWindowListener(new WindowAdapter() {

            public void windowClosing(WindowEvent e) {
                super.windowClosing(e);
                close();
                System.exit(0);
            }

        });
        //设置表格

        Object[][] tableData = {};
        tableModel = new MyTableModel(tableData, titles);
        jtable = new JTable(this.tableModel);
        JScrollPane scr = new JScrollPane(this.jtable);
        scr.setBounds(430, 10, 200, 290);
        panel.add(scr);
        //添加标格监听事件
        jtable.addMouseListener(new MouseAdapter() {
            public void mouseClicked(MouseEvent e) {
                int row = jtable.getSelectedRow();
                if (jtable.getSelectedColumn() == 0)//如果是第一列的单元格，则返回，不响应点击
                    return;
                //列响应操作
            }
        });

        //显示操作信息label
        labelInfo = new JLabel("");
        labelInfo.setForeground(Color.RED);
        labelInfo.setBounds(20, 317, 600, 60);
        panel.add(labelInfo);

        //初始化配置信息和数据库下拉列表
//		dbMap = dbutil.getDbConfigMap();
//		for(String key : dbMap.keySet()){
//			this.getDbBox().addItem(key);
//		}
    }

    public static void main(String[] args) {
        // TODO Auto-generated method stub
        // 创建对象
        BeanRobot dtb = new BeanRobot();
        // 设置可见
        dtb.setVisible(true);
        // 点击X关闭窗口
        dtb.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        // 调用设置居中显示
        dtb.setSizeAndCentralizeMe(680, 440);

    }

    // 设置居中
    private void setSizeAndCentralizeMe(int width, int height) {
        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        this.setSize(width, height);
        this.setLocation(screenSize.width / 2 - width / 2, screenSize.height
                / 2 - height / 2);
    }

    public void createBean() {
        String catName = this.getCatField().getText().replace("\\","\\\\");
        String packName = this.getPackField().getText();

//        if ((new File(catName).isDirectory()) != true) {
//            this.getLabelInfo().setText("目录不存在，请重新输入");
//            return;
//        }

        String catPack = catName + File.separator + packName;
        catPack = catPack.replace(".", "/");
        new File(catPack).mkdirs();
        int rowCount = this.jtable.getRowCount();
        for (int i = 0; i < rowCount; i++) {
            String tableName = this.jtable.getValueAt(i, 1).toString();

            String database = getIpFiled().getText().replace("\\", "\\\\");
            Connection connection = null;
            try {
                connection = DriverManager.getConnection("jdbc:sqlite:" + database);
                Statement statement = connection.createStatement();
                statement.setQueryTimeout(30);  // set timeout to 30 sec.


                Statement statement2 = connection.createStatement();
                ResultSet rsCol = statement2.executeQuery("PRAGMA table_info(" + tableName + ")");

                StringBuilder fields = new StringBuilder();
                StringBuilder methods = new StringBuilder();

                StringBuilder classInfo = new StringBuilder("\t/**\r\n\t ");

                while (rsCol.next()) {
                    ResultSetMetaData rsmd1 = rsCol.getMetaData();
                    String colName = rsCol.getString("name");
                    String colType = rsCol.getString("type");
                    int colIndex = rsCol.getInt("pk");
                    boolean bIndex = false;
                    if (colIndex > 0)
                        bIndex = true;
                    System.out.println("\tcol:" + colName + " " + colType + " " + bIndex + " " + colIndex);
                    String field = colName;
                    String type = typeTrans(colType);
                    if(bIndex==true){
                        //fields.append("@Id(autoincrement = true)\r\n");
                        fields.append("@Id\r\n");
                    }
                    fields.append(getFieldStr(field, type));
                    methods.append(getMethodStr(field, type));
                }

                classInfo.append("  sf");
                classInfo.append("\r\n\t*/\r\n\r\n");

                classInfo.append("import org.greenrobot.greendao.annotation.Entity;\n" +
                        "import org.greenrobot.greendao.annotation.Id;\r\n\n");
                classInfo.append("@Entity\r\n");
                classInfo.append("public class ").append(upperFirestChar(tableName))
                        .append(" {\r\n");
                classInfo.append(fields);
                classInfo.append("\r\n");
                classInfo.append(methods);
                classInfo.append("\r\n");
                classInfo.append("}");

                File file = new File(catPack, upperFirestChar(tableName) + ".java");

                FileWriter fw = new FileWriter(file);
                String packageinfo = "package " + packName + ";\r\n\r\n";
                fw.write(packageinfo);

                fw.write(classInfo.toString());
                fw.flush();
                fw.close();


            } catch (Exception e) {
                // if the error message is "out of memory",
                // it probably means no database file is found
                System.err.println(e.getMessage());
            } finally {
                try {
                    if (connection != null)
                        connection.close();
                } catch (SQLException e) {
                    // connection close failed.
                    System.err.println(e);
                }
            }
        }
    }


    //http://www.cnblogs.com/shishm/archive/2012/01/30/2332142.html
    //数据库字段类型与JAVA类型转换
    public String typeTrans(String type) {
        if (type.contains("BOOLEAN")) {
            return "boolean";
        } else if (type.contains("INTEGER")) {
            return "int";
        } else if (type.contains("FLOAT")) {
            return "double";
        } else if (type.contains("REAL")) {
            return "float";
        } else if (type.contains("NUMERIC")) {
            return "java.math.BigDecimal";
        } else if (type.contains("TIME")) {
            return "java.sql.Time";
        } else if (type.contains("DATE")) {
            return "java.sql.Date";
        } else if (type.contains("TIMESTAMP")) {
            return "java.sql.Date";
        } else if (type.contains("varchar") || type.contains("NVARCHAR")
                || type.contains("TEXT")) {
            return "String";
        } else if (type.contains("binary") || type.contains("blob")) {
            return "byte[]";
        } else {
            return "String";
        }
    }


    //获取方法字符串
    private String getMethodStr(String field, String type) {
        StringBuilder get = new StringBuilder("\tpublic ");
        get.append(type).append(" ");
        if (type.equals("boolean")) {
            get.append(field);
        } else {
            get.append("get");
            get.append(upperFirestChar(field));
        }
        get.append("(){").append("\r\n\t\treturn this.").append(field)
                .append(";\r\n\t}\r\n");
        StringBuilder set = new StringBuilder("\tpublic void ");

        if (type.equals("boolean")) {
            set.append(field);
        } else {
            set.append("set");
            set.append(upperFirestChar(field));
        }
        set.append("(").append(type).append(" ").append(field)
                .append("){\r\n\t\tthis.").append(field).append("=")
                .append(field).append(";\r\n\t}\r\n");
        get.append(set);
        return get.toString();
    }

    //首字母大写
    public String upperFirestChar(String src) {
        return src.substring(0, 1).toUpperCase().concat(src.substring(1));
    }

    //获取字段
    private String getFieldStr(String field, String type) {
        StringBuilder sb = new StringBuilder();
        sb.append("\t").append("private ").append(type).append(" ")
                .append(field).append(";");
        sb.append("\r\n");
        return sb.toString();
    }


    public List<String> getTableName() {

        String database = getIpFiled().getText().replace("\\", "\\\\");
        Connection connection = null;
        List<String> lst = new ArrayList<>();
        try {
            connection = DriverManager.getConnection("jdbc:sqlite:" + database);
            Statement statement = connection.createStatement();
            statement.setQueryTimeout(30);  // set timeout to 30 sec.


            ResultSet rsTable = statement.executeQuery("select name from sqlite_master where type='table' order by name");
            while (rsTable.next()) {
                // read the result set
                ResultSetMetaData rsmd = rsTable.getMetaData();
//                System.out.println(rsmd.getColumnCount());
                String tableName = rsTable.getString("name");
                System.out.println("\ntable name = " + tableName);
                lst.add(tableName);
//                System.out.println("id = " + rs.getInt("id"));
//                Statement statement2 = connection.createStatement();
//                ResultSet rsCol = statement2.executeQuery("PRAGMA table_info(" + tableName + ")");
//                while (rsCol.next()) {
//                    ResultSetMetaData rsmd1 = rsCol.getMetaData();
//                    String colName = rsCol.getString("name");
//                    String colType = rsCol.getString("type");
//                    int colIndex = rsCol.getInt("pk");
//                    boolean bIndex = false;
//                    if (colIndex > 0)
//                        bIndex = true;
//                    System.out.println("\tcol:" + colName + " " + colType + " " + bIndex + " " + colIndex);
//                }
            }
        } catch (SQLException e) {
            // if the error message is "out of memory",
            // it probably means no database file is found
            System.err.println(e.getMessage());
        } finally {
            try {
                if (connection != null)
                    connection.close();
            } catch (SQLException e) {
                // connection close failed.
                System.err.println(e);
            }
        }
        return lst;
    }

    public void go() {
//		this.getLabelInfo().setText("");
//		initInfo();
//		String selTableStr = dbInfoMap.get("showTable").toString();
        //获取表名
        List<String> tableList = getTableName();//dbutil.getTableNames(dbInfoMap, dbInfoMap.get("dbName").toString());
        if (tableList == null) {
            int rowCount = this.getTableModel().getRowCount();
            int delInd = 0;
            while (delInd < rowCount) {
                this.getTableModel().removeRow(0);
                delInd++;
            }
            this.getLabelInfo().setText("数据库连接异常");
        } else {
            int rowCount = this.getTableModel().getRowCount();
            int delInd = 0;
            while (delInd < rowCount) {
                this.getTableModel().removeRow(0);
                delInd++;
            }
            for (String tName : tableList) {
                Object[] rowData = {new Boolean(true), tName};
                this.getTableModel().addRow(rowData);
            }


        }

    }

    public void initInfo() {
        //读取配置文件数据库配置
//		String user = this.getUserField().getText();
//		String pass = this.getPwdField().getText();
//		String ip = this.getIpFiled().getText();
//		String database = this.getDbNameFiled().getText();
//		String dbName = this.getDbBox().getSelectedItem().toString();
//		String packName =this.getPackField().getText();
//		String catName =this.getCatField().getText();
//		//处理界面数据
//		dbInfoMap = new HashMap();
//		dbInfoMap = dbMap.get(dbName);
//		dbInfoMap.put("userName", user);
//		dbInfoMap.put("userpwd", pass);
//		dbInfoMap.put("jdbc", dbMap.get(dbName).get("JdbcURL")+ip+dbMap.get(dbName).get("dbStr")+database);
//		dbInfoMap.put("driver", dbMap.get(dbName).get("driverClassName"));
//		dbInfoMap.put("dbName", database);
//		dbInfoMap.put("packName", packName);
//		dbInfoMap.put("catName", catName);

    }

    private void close() {
        System.out.println("关闭事件");
    }

    public JTextField getIpFiled() {
        return ipFiled;
    }

    public void setIpFiled(JTextField ipFiled) {
        this.ipFiled = ipFiled;
    }

    public JTextField getDbFiled() {
        return dbFiled;
    }

    public void setDbFiled(JTextField dbFiled) {
        this.dbFiled = dbFiled;
    }

    public JTextField getTabField() {
        return tabField;
    }

    public void setTabField(JTextField tabField) {
        this.tabField = tabField;
    }

    public JTextField getPackField() {
        return packField;
    }

    public void setPackField(JTextField packField) {
        this.packField = packField;
    }

    public JTextField getCatField() {
        return catField;
    }

    public void setCatField(JTextField catField) {
        this.catField = catField;
    }

    public JCheckBox getCheckBox() {
        return checkBox;
    }

    public void setCheckBox(JCheckBox checkBox) {
        this.checkBox = checkBox;
    }


//	public JTextField getUserField() {
//		return userField;
//	}
//
//	public void setUserField(JTextField userField) {
//		this.userField = userField;
//	}
//
//	public JTextField getPwdField() {
//		return pwdField;
//	}
//
//	public void setPwdField(JTextField pwdField) {
//		this.pwdField = pwdField;
//	}
//
//	public JTextField getDbNameFiled() {
//		return dbNameFiled;
//	}
//
//	public void setDbNameFiled(JTextField dbNameFiled) {
//		this.dbNameFiled = dbNameFiled;
//	}

    public JComboBox getDbBox() {
        return dbBox;
    }

    public void setDbBox(JComboBox dbBox) {
        this.dbBox = dbBox;
    }

    public JLabel getLabelInfo() {
        return labelInfo;
    }

    public void setLabelInfo(JLabel labelInfo) {
        this.labelInfo = labelInfo;
    }

    public JTable getJtable() {
        return jtable;
    }

    public void setJtable(JTable jtable) {
        this.jtable = jtable;
    }


    public MyTableModel getTableModel() {
        return tableModel;
    }

    public void setTableModel(MyTableModel tableModel) {
        this.tableModel = tableModel;
    }


    class MyTableModel extends DefaultTableModel {
        public MyTableModel(Object[][] data, String[] columns) {
            super(data, columns);
        }

        public boolean isCellEditable(int row, int column) { //设置Table单元格是否可编辑
            if (column == 0) return true;
            return false;
        }

        public Class<?> getColumnClass(int columnIndex) {
            if (columnIndex == 0) {
                return Boolean.class;
            }
            return Object.class;
        }

    }
}
