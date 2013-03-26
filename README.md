# ThinReports + Rails サンプル

## シチュエーション
見積もりのモデル（estimate）のPDFを出力したいと想定

## 用意

### モデルの用意
見積もり（estimate）モデル

|attribute|内容|
| --- | ----|
|customer|見積書番号|
|place|場所|
|total_price|見積金額|  

```
class Estimate < ActiveRecord::Base
  attr_accessible :customer, :no, :place, :total_price
end
```

### gemの追加
#### Gemfile
```
gem 'thinreports-rails'
```

## コード

### PDF出力用のアドレス設定
サンプルではPDF出力用にreportと言うルーティングを設定。  
既存のCRUDの中でshow等を使用する場合は新たなルーティングは不要。

#### config/routes.rb
```
resources :estimates do
  member do
    get :report
  end
end
```

### Controller
サンプルでは新たにreportのルーティングを設定したので、
コントローラーにもメソッドを追加。  
既存のルーティングにPDF出力機能を持たせたいならば、
respond_toブロックの中にformat.pdfを追加するだけでOK。
#### app/controllers/estimates_controller.rb
```
def report
  @estimate = Estimate.find(params[:id])

  respond_to do |format|
    format.pdf
  end
end
```

### レイアウトに変数の流し込み
モデルのviews以下に、レイアウトファイル（.tlf）と  
レイアウトの変数設定ファイル（.pdf.thinreports）を設置。  
拡張子前が設定したルーティングと同一になるように注意。

#### app/views/estimates/report.pdf.thinreports
```
report.set_layout # Required!
report.start_new_page
report.page.values no: @estimate.no
report.page.values customer: @estimate.customer
report.page.values total_price: @estimate.total_price
report.page.values place: @estimate.place
report.page.values created_at: @estimate.created_at
```

### PDF閲覧用リンク
formatの指定が重要

#### app/views/estimates/show.html.erb 等
```
<%= link_to 'show pdf', report_estimate_path(@estimate, format: 'pdf') %>
```
