# tg-ws-proxy-flake

**Nix flake для tg-ws-proxy** - локального SOCKS5-прокси, который сильно
ускоряет Telegram Desktop через WebSocket.

Неофициальная Nix-упаковка оригинального проекта
[Flowseal/tg-ws-proxy](https://github.com/Flowseal/tg-ws-proxy) (MIT-лицензия).

## Быстрый старт

Запуск прокси:

```bash
nix run github:pialtor/tg-ws-proxy-flake -- --port 1080
```

Прокси запустится на 127.0.0.1:1080 SECRET для MTPROTO будет в терминале.

## Другой порт или слушать на всех интерфейсах

```bash
nix run github:pialtor/tg-ws-proxy-flake -- --port 8080 --host 0.0.0.0
```

## Посмотреть все возможные параметры

```bash
nix run github:pialtor/tg-ws-proxy-flake -- --help
```

## Использование как input в своём flake.nix

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    tg-ws-proxy.url = "github:pialtor/tg-ws-proxy-flake";
  };

  outputs = { self, nixpkgs, tg-ws-proxy, ... }:
    let
      system = "x86_64-linux"; # или "aarch64-linux"
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.tg-ws-proxy = tg-ws-proxy.packages.${system}.default;
      apps.${system}.tg-ws-proxy = tg-ws-proxy.apps.${system}.default; # Если нужен запуск одной командой
    };
}
```

### После этого:

```bash
nix run .#tg-ws-proxy -- --port 1080
# или
nix build .#tg-ws-proxy
```

## Что внутри

- `packages.<system>.default` - готовый пакет прокси (можно использовать в
  `environment.systemPackages`, Home Manager и т.д.)
- `apps.<system>.default` - приложение для быстрого запуска через `nix run`
- Поддержка двух архитектур: `x86_64-linux` и `aarch64-linux`
- Полная воспроизводимость благодаря `flake.lock`

## Лицензия

MIT (как у оригинального проекта).

Весь код прокси принадлежит [Flowseal](https://github.com/Flowseal) и
контрибьюторам оригинального репозитория.\
Этот flake - только удобная Nix-обёртка.
