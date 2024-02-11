# codepipeline-template

CodePipelineを作成するterraform テンプレート。

CodePipelineは以下のステージを持つ。

* Gitリポジトリ(CodeStar Connections)のpushをトリガーにアーティファクトを作成するソースステージ
* アーティファクトをビルドしてECRにコンテナイメージをphsh＆イメージタグを作成するビルドステージ


