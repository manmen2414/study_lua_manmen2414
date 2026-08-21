接続されてる全部のストレージの設定割合のスロットが埋まっている場合Discordへ警告を送信する。

```lua
return {
  DISCORD_WEBHOOK = "",   --Webhook URL
  NAME = "",              --ストレージの名前
  PERCENTAGE_ERROR = 100, --これ以上スロットが占有されるとエラーを送信する(パーセント)
  PERCENTAGE_CLEAN = 75,  --これ以下(同数の場合は未満)スロットが開放されると復帰通知を送信する(パーセント)
}
```