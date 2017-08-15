package org.github.yippee.china_poem.poem2db.bean;

import org.greenrobot.greendao.annotation.Entity;
import org.greenrobot.greendao.annotation.Generated;
import org.greenrobot.greendao.annotation.Id;
import org.greenrobot.greendao.annotation.Index;

/**
 * Created by sf on 2017/7/25.
 */

@Entity(nameInDb="tangshi",

    indexes = {
    @Index(value = "author,title,strains", unique = true)
    }

        )

public class Tangshi {
  @Id
  Long id;

  public Long getId() {
    return id;
  }

  private String author;
  private String title;

  private String strains;
  private String paragraphs;

  private String pyquany;
  private String pyjian;
  private String authorjt;

  public void setId(Long id) {
    this.id = id;
  }

  public String getAuthor() {
    return author;
  }

  public void setAuthor(String author) {
    this.author = author;
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getStrains() {
    return strains;
  }

  public void setStrains(String strains) {
    this.strains = strains;
  }

  public String getParagraphs() {
    return paragraphs;
  }

  public void setParagraphs(String paragraphs) {
    this.paragraphs = paragraphs;
  }

  public String getPyquany() {
    return pyquany;
  }

  public void setPyquany(String pyquany) {
    this.pyquany = pyquany;
  }

  public String getPyjian() {
    return pyjian;
  }

  public void setPyjian(String pyjian) {
    this.pyjian = pyjian;
  }

  public String getAuthorjt() {
    return authorjt;
  }

  public void setAuthorjt(String authorjt) {
    this.authorjt = authorjt;
  }

  public String getPyquan() {
    return pyquan;
  }

  public void setPyquan(String pyquan) {
    this.pyquan = pyquan;
  }

  private String pyquan;

  @Generated(hash = 1930148604)
  public Tangshi(Long id, String author, String title, String strains,
          String paragraphs, String pyquany, String pyjian, String authorjt,
          String pyquan) {
      this.id = id;
      this.author = author;
      this.title = title;
      this.strains = strains;
      this.paragraphs = paragraphs;
      this.pyquany = pyquany;
      this.pyjian = pyjian;
      this.authorjt = authorjt;
      this.pyquan = pyquan;
  }

  @Generated(hash = 26218254)
  public Tangshi() {
  }

}

