package org.github.yippee.tangshi;

import java.util.List;

/**
 * Created by sf on 2017/7/25.
 */

public class TsBean {
  /**
   * strains : ["平平仄仄平平仄，仄仄仄平平仄平。","平仄平平仄平仄，平平平仄仄平平。","仄平平仄平平仄，平仄平平仄仄平。","仄仄平平平仄仄，平平平仄仄平平。"]
   * author : 李長沙
   * paragraphs : ["平時已秉班揚筆，暇處不妨甘石經。","吾里忻傳日邊信，君言頻中斗杓星。","會稽夫子餘詩禮，巴蜀君平舊典型。","歷歷周天三百度，更參璿玉到虞廷。"]
   * title : 贈談命嚴叔寓
   */

  private String author;
  private String title;
  private List<String> strains;
  private List<String> paragraphs;

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

  public List<String> getStrains() {
    return strains;
  }

  public void setStrains(List<String> strains) {
    this.strains = strains;
  }

  public List<String> getParagraphs() {
    return paragraphs;
  }

  public void setParagraphs(List<String> paragraphs) {
    this.paragraphs = paragraphs;
  }
}
