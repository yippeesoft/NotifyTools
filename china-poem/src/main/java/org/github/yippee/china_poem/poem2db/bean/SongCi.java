package org.github.yippee.china_poem.poem2db.bean;

import android.os.Parcel;
import android.os.Parcelable;
import org.greenrobot.greendao.annotation.Entity;
import org.greenrobot.greendao.annotation.Id;
import org.greenrobot.greendao.annotation.Index;
import org.greenrobot.greendao.annotation.Property;
import org.greenrobot.greendao.annotation.Generated;
import org.greenrobot.greendao.annotation.Transient;

/**
 * Created by sf on 2017/8/18.
 */


@Entity(nameInDb="ci"
)

public class SongCi implements Parcelable {
  @Id @Property(nameInDb = "value") Long id;

  public Long getId() {
    return id;
  }

  private String author;
  private String rhythmic;

  private String content;
  private String pyquan;

  public void setId(Long id) {
    this.id = id;
  }

  public String getAuthor() {
    return author;
  }

  public void setAuthor(String author) {
    this.author = author;
  }

  public String getRhythmic() {
    return rhythmic;
  }

  public void setRhythmic(String rhythmic) {
    this.rhythmic = rhythmic;
  }

  public String getContent() {
    return content;
  }

  public void setContent(String content) {
    this.content = content;
  }

  public String getPyquan() {
    return pyquan;
  }

  public void setPyquan(String pyquan) {
    this.pyquan = pyquan;
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

  private String pyquany;
  private String pyjian;

  @Transient
  private int count;

  public int getCount() {
    return count;
  }

  public void setCount(int count) {
    this.count = count;
  }

  @Override public int describeContents() {
    return 0;
  }

  @Override public void writeToParcel(Parcel dest, int flags) {
    dest.writeValue(this.id);
    dest.writeString(this.author);
    dest.writeString(this.rhythmic);
    dest.writeString(this.content);
    dest.writeString(this.pyquan);
    dest.writeString(this.pyquany);
    dest.writeString(this.pyjian);
  }

  public SongCi() {
  }

  protected SongCi(Parcel in) {
    this.id = (Long) in.readValue(Long.class.getClassLoader());
    this.author = in.readString();
    this.rhythmic = in.readString();
    this.content = in.readString();
    this.pyquan = in.readString();
    this.pyquany = in.readString();
    this.pyjian = in.readString();
  }

  @Generated(hash = 590738613)
  public SongCi(Long id, String author, String rhythmic, String content, String pyquan,
          String pyquany, String pyjian) {
      this.id = id;
      this.author = author;
      this.rhythmic = rhythmic;
      this.content = content;
      this.pyquan = pyquan;
      this.pyquany = pyquany;
      this.pyjian = pyjian;
  }

  public static final Parcelable.Creator<SongCi> CREATOR = new Parcelable.Creator<SongCi>() {
    @Override public SongCi createFromParcel(Parcel source) {
      return new SongCi(source);
    }

    @Override public SongCi[] newArray(int size) {
      return new SongCi[size];
    }
  };
}