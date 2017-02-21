package org.github.yippee.notifytools.view;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.pdf.PdfRenderer;
import android.net.Uri;
import android.os.Bundle;
import android.os.ParcelFileDescriptor;
import android.support.design.widget.CoordinatorLayout;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v4.view.MenuItemCompat;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.SearchView;
import android.support.v7.widget.Toolbar;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import org.github.yippee.notifytools.R;
import org.github.yippee.notifytools.utils.Logs;
import org.w3c.dom.Text;

import java.io.File;

import uk.co.senab.photoview.PhotoViewAttacher;

public class PdfActivity extends AppCompatActivity {
    private Logs log = Logs.getLogger(this.getClass());


    TextView txtTitle;
    EditText edtPage;
    ImageView imgPdf;
    Toolbar toolbar;

    private ParcelFileDescriptor mFileDescriptor;
    private PdfRenderer mPdfRenderer;
    private PdfRenderer.Page mCurrentPage;
    PhotoViewAttacher mAttacher;
    FloatingActionButton fab;
    CoordinatorLayout rlmain;
    int index = 0;
    Uri uri;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pdf);
        toolbar = (Toolbar) findViewById(R.id.toolbar);

        toolbar.setLogo(R.drawable.ic_notify);
        toolbar.setTitle("PdfView");
//        toolbar.setTitleTextColor(Color.RED);
        setSupportActionBar(toolbar);

        imgPdf=(ImageView)findViewById(R.id.image_pdf);
        mAttacher = new PhotoViewAttacher(imgPdf);

        txtTitle=(TextView) findViewById(R.id.toolbar_title);
        txtTitle.setGravity(Gravity.START);
//        txtTitle.setBackgroundColor(Color.RED);
        edtPage=(EditText) findViewById(R.id.toolbar_page);
        edtPage.setGravity(Gravity.END|Gravity.CENTER);
//        edtPage.setBackgroundColor(Color.YELLOW);

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
            }
        });

        Intent intent = getIntent();
        if (intent != null) {
            log.d("oncreate "+intent.toString());
            String action = intent.getAction();
            if (intent.ACTION_VIEW.equals(action)) {
                uri = intent.getData();
                log.d("ACTION_VIEW uri "+ uri.toString());
                openRenderer( );
                if(mPdfRenderer!=null)
                    showPage(index);
            }
        }
    }
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        switch (id){
            case R.id.action_left:
                index--;
                if(index<0)
                    index=0;
                showPage(index);
                break;
            case R.id.action_right:
                index++;
                showPage(index);
                break;
        }

        return super.onOptionsItemSelected(item);
    }

    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_pdf ,menu);
//        MenuItem menuItem=menu.findItem(R.id.search);//
//        SearchView searchView= (SearchView) MenuItemCompat.getActionView(menuItem);//加载searchview
////        searchView.setOnQueryTextListener(this);//为搜索框设置监听事件
////        searchView.setSubmitButtonEnabled(true);//设置是否显示搜索按钮
//        searchView.setQueryHint("查找");//设置提示信息
//        searchView.setIconifiedByDefault(true);//设置搜索默认为图标
        return  true; }

    private void openRenderer( )  {
        // In this sample, we read a PDF from the assets directory.
        File f = new File(uri.getPath());
        try {
            mFileDescriptor = ParcelFileDescriptor.open(f, ParcelFileDescriptor.MODE_READ_ONLY);
            mPdfRenderer = new PdfRenderer(mFileDescriptor);
            cnt=mPdfRenderer.getPageCount();
        } catch (Exception e) {
            log.e(e);
        }
    }

    int cnt=0;
    private void showPage(int indexx) {

        if (mPdfRenderer.getPageCount() <= indexx) {
            index=mPdfRenderer.getPageCount()-1;
            return;
        }
        // Make sure to close the current page before opening another one.
        if (null != mCurrentPage) {
            mCurrentPage.close();
        }
        // Use `openPage` to open a specific page in PDF.
        mCurrentPage = mPdfRenderer.openPage(index);
        // Important: the destination bitmap must be ARGB (not RGB).
        Bitmap bitmap = Bitmap.createBitmap(mCurrentPage.getWidth(), mCurrentPage.getHeight(),
                Bitmap.Config.ARGB_8888);
        // Here, we render the page onto the Bitmap.
        // To render a portion of the page, use the second and third parameter. Pass nulls to get
        // the default result.
        // Pass either RENDER_MODE_FOR_DISPLAY or RENDER_MODE_FOR_PRINT for the last parameter.
        mCurrentPage.render(bitmap, null, null, PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY);
        // We are ready to show the Bitmap to user.
        imgPdf.setImageBitmap(bitmap);
        mAttacher.update();
        updateUi();
    }

    private void updateUi() {
        int index = mCurrentPage.getIndex();
        int pageCount = mPdfRenderer.getPageCount();
        toolbar.setSubtitle(new File(uri.getPath()).getName());
        txtTitle.setText(new File(uri.getPath()).getName()+" "+cnt);
        edtPage.setText((index+1)+"");
        edtPage.setSelection(edtPage.getText().length());
//        setTitle("Page:"+index + 1+"\t"+ pageCount);
    }
}
