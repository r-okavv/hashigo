module ApplicationHelper
  def default_meta_tags
    {
      site: 'HASHIGO',
      title: '二次会会場を迅速に選ぶサポートアプリ',
      reverse: true,
      charset: 'utf-8',
      description: '近くの高評価店舗を即座に絞り込み！今すぐHASHIGOを使ってスムーズなお店選びを体験しましょう！',
      keywords: 'スポーツ,スポーツ施設,東京',
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png'), # 配置するパスやファイル名によって変更すること
        local: 'ja-JP'
      },
      # Twitter用の設定を個別で設定する
      twitter: {
        card: 'summary_large_image', # Twitterで表示する場合は大きいカードにする
        site: '@', # アプリの公式Twitterアカウントがあれば、アカウント名を書く
        image: image_url('ogp.png') # 配置するパスやファイル名によって変更すること
      }
    }
  end
end
