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

  private byte[] author;
  private byte[] title;

  private byte[] strains;

  private byte[] paragraphs;

  @Generated(hash = 620167664)
  public Tangshi(Long id, byte[] author, byte[] title, byte[] strains,
          byte[] paragraphs) {
      this.id = id;
      this.author = author;
      this.title = title;
      this.strains = strains;
      this.paragraphs = paragraphs;
  }


  @Generated(hash = 26218254)
  public Tangshi() {
  }


  public void setId(Long id) {
      this.id = id;
  }


  public byte[] getAuthor() {
      return this.author;
  }


  public void setAuthor(byte[] author) {
      this.author = author;
  }


  public byte[] getTitle() {
      return this.title;
  }


  public void setTitle(byte[] title) {
      this.title = title;
  }


  public byte[] getStrains() {
      return this.strains;
  }


  public void setStrains(byte[] strains) {
      this.strains = strains;
  }


  public byte[] getParagraphs() {
      return this.paragraphs;
  }


  public void setParagraphs(byte[] paragraphs) {
      this.paragraphs = paragraphs;
  }
}

