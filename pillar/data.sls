#!yaml|gpg
info: some data
motd: hello there :)

ports:
  node_exporter: 9100
  prometheus: 9101


roles:
  debian-s-1vcpu-1gb-sfo2-01:
    wireguard: server
    public_ip: 157.230.168.108
  pecan:
    wireguard: client

databases:
  postgres-main:
    version: 9.6
    user: postgres
    password: |
      -----BEGIN PGP MESSAGE-----

      hQGMAyRAvboUiVyYAQv/S4mUK/z+1nBGw8+QIDzX5zQovek1tlw12Rh1fI7p9v1c
      xK3Rma0w5B1JpUc+DIictzl6A6R0u6Kk1QZ1E7UDNph4OgGF+lFvDXW3lFms+83E
      HjQCm54oH6i16L73Wdv/Uar9q9nhrePCpfKYEdP89zHujNYDMtLxKBcoo0iVIeix
      Nql0B25Lw0HDzAlcGuel4mK4kaw2BgJyfLxNYnFWVlcHKtnAK/o2xI/6IHJpILqh
      E5C1phn+wKn5zPCbIJF2FYw/XGWa3UX7qxZoUqMG0xst7pC6sv0moy/6r/Jx38xb
      7o53dcrgXUxqAI4cksJ99kh1YhNqyFp7DWvnuRhgdsa1BGeuXNnhRWcnEkMxl7XK
      DUybPEWD9fo5v9D4ICkHqPcBYKjAD9ZiGgzM0VkOTh42EX1TfzlbhxE6tbbotqZj
      S2NJuZKr2TA7St5asAYAQhL4O+86FSQ/fRC6WiPyQKWGfO47e33LgOyg71LBG59r
      NXqTWWZw8oYDZ1g0datV0kQBHpp0ZI9IKiB8Nc8ZbbIGYSROaFcoZpvQxRBmtWci
      ycBBtwb6eGBKCw37n5Z2ZM3325MEDTaHbhRbp2pkww3PO09b7A==
      =O4Wn
      -----END PGP MESSAGE-----
    address: 34.66.204.3
    port: 5432

netbox:
  secret-key: |
    -----BEGIN PGP MESSAGE-----

    hQGMAyRAvboUiVyYAQv+O0TvKZvbTN88yFyh9WKyt3D/n6QWImqU28wM8d3tct+2
    2a55ZjK2tM1lGgnbfSSyotfWoK4X8e6seglfxF0QyumQLuIeeCozSLJDiKXElXhM
    yEXgolcMR/bOVQTEeSUvrdW/U5caZwkMDhzOVDXMc+58l75MaOazFr3W4lABNrab
    q4n+B+xm19sX0c2y1Sb6ZHBD8hLoP72GhjBqoYr+hynLJUx+xhUMbtxveMa7LL7k
    AaSLRLq85zEq2JDI0OlvtG0ga0lpA071GKTct2jNBLu+bKFiS7MoOxCV6JYYhg8w
    kuev8KXhLpW7lo+UUKJY1LtvAN3Ck9iuygJ4R2C+yqBn7B6H1QIl4UwU1DQKaZY3
    mgGL7KsYHrQ8Jrfjm4TJZn29q+wEvV5Cn9ToNOsn0lpMwukR29oJcItBoLsOniHX
    FLCrqqERPGEzXFtuJpqNDfPrSP0WLakbU/YldgUQdJZG0AtrKRJO3yEz8Qy3Jt7v
    FR+HBhXF7STfkeQ03eCE0kgBkGiFb/wCRHboXNcEVMTMdEmRnVtyuhU697ChQ+Cz
    mT5t/iIxyv02Zf7fpXxUDlWVjBvX8wmAin8YO0o+7HPG/lgJITm1Rgc=
    =JRhc
    -----END PGP MESSAGE-----
grafana:
  admin-password: |
    -----BEGIN PGP MESSAGE-----

    hQGMAyRAvboUiVyYAQwAsSLEM3Kgx5K+qUIJ7/zcDPL086EfjLVbH14YZrfDI1Ol
    DY+GAn4rov5ZKnTFEpTzGcqRlUtcICZolooZQjKeE7lufwjQgyAyddpuiWnaXtIV
    ULieYcexBfOgJclJQBq0CAP46nRgf0Ly1venHRZNbNr4rFVSeU8xVAofaBwx8SYe
    PCANDPL2FSASsKeT3EZJMBssTLK/qI+M+bch1b3YVg+ICSSZlP2kGB7ewRWNGyPe
    CNGSWFy/VfjnYNYeAPbbub/MEo11VswFnBIOn0iZXflb2JMYSNQaG82pAOj+18Fr
    VOw/8TgdQYPteXdi+wnqRqJTAvWyRUiUGfwAaPZPl5gMpBTxku8M57W0fi6cdzUh
    7pK+nkwiMC5bVLFYCyYLunDdZZm15LEzJYxZCW/76i6bLw4CDnwieKwCjW0DT3wZ
    xdkWHO/fSwDuYST/fhGZ1I6jrRvTXkTD1zzCSOpd/k3ewCInV1mBOgUColtZhIhm
    ZrkK1mZi+vh4IkwiR3nG0kgBQNpQ3i9m+BUkU2CDgPEZi0L3IdWY4lMZ+o1bQ/fu
    l87Yj2Q3Lav9XeyUFaS1wiXMCMNvExKH8E4dB1WP9vI4dh5MTaN+L3g=
    =Uay6
    -----END PGP MESSAGE-----