package org.github.yippee.china_poem.poem2db.bean;

import android.os.Parcel;
import android.os.Parcelable;
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

public class Tangshi implements Parcelable {
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

  @Override public int describeContents() {
    return 0;
  }

  @Override public void writeToParcel(Parcel dest, int flags) {
    dest.writeValue(this.id);
    dest.writeString(this.author);
    dest.writeString(this.title);
    dest.writeString(this.strains);
    dest.writeString(this.paragraphs);
    dest.writeString(this.pyquany);
    dest.writeString(this.pyjian);
    dest.writeString(this.authorjt);
    dest.writeString(this.pyquan);
  }

  protected Tangshi(Parcel in) {
    this.id = (Long) in.readValue(Long.class.getClassLoader());
    this.author = in.readString();
    this.title = in.readString();
    this.strains = in.readString();
    this.paragraphs = in.readString();
    this.pyquany = in.readString();
    this.pyjian = in.readString();
    this.authorjt = in.readString();
    this.pyquan = in.readString();
  }

  public static final Parcelable.Creator<Tangshi> CREATOR = new Parcelable.Creator<Tangshi>() {
    @Override public Tangshi createFromParcel(Parcel source) {
      return new Tangshi(source);
    }

    @Override public Tangshi[] newArray(int size) {
      return new Tangshi[size];
    }
  };
}

