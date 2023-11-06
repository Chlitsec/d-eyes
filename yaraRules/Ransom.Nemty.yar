rule Fusion
{
meta:
  description= "Detect the risk of Ransomware Nemty Rule 1"

strings:
	$s1 = "main.getdrives" ascii wide
	$s2 = "main.SaveNote" ascii wide
	$s3 = "main.FileSearch" ascii wide
	$s4 = "main.BytesToPublicKey" ascii wide
	$s5 = "main.GenerateRandomBytes" ascii wide

	$x1 = /Fa[i1]led to fi.Close/ ascii wide
	$x2 = /Fa[i1]led to fi2.Close/ ascii wide
	$x3 = /Fa[i1]led to get stat/ ascii wide
	$x4 = /Fa[i1]led to os.OpenFile/ ascii wide

	$pdb1 = "C:/OpenServer/domains/build/aes.go" ascii wide
	$pdb2 = "C:/Users/eugene/Desktop/test go/test.go" ascii wide
	//C:/Users/eugene/Desktop/web/src/aes_sGHR6SQYlVm0COgz.go
	$pdb3 = "C:/Users/eugene/Desktop/web/src/aes_" ascii wide

condition:
	4 of ($s*) or 3 of ($x*) or any of ($pdb*)
}

rule win_nemty_auto {

    meta:
        description= "Detect the risk of Ransomware Nemty Rule 2"

    strings:
        $sequence_0 = { 7406 53 e8???????? 8347041c 5e 5b c3 }
            // n = 7, score = 300
            //   7406                 | je                  8
            //   53                   | push                ebx
            //   e8????????           |                     
            //   8347041c             | add                 dword ptr [edi + 4], 0x1c
            //   5e                   | pop                 esi
            //   5b                   | pop                 ebx
            //   c3                   | ret                 

        $sequence_1 = { 8bcf 8b35???????? 03f1 83f810 }
            // n = 4, score = 300
            //   8bcf                 | mov                 ecx, edi
            //   8b35????????         |                     
            //   03f1                 | add                 esi, ecx
            //   83f810               | cmp                 eax, 0x10

        $sequence_2 = { 83f906 7524 83f801 7507 }
            // n = 4, score = 300
            //   83f906               | cmp                 ecx, 6
            //   7524                 | jne                 0x26
            //   83f801               | cmp                 eax, 1
            //   7507                 | jne                 9

        $sequence_3 = { 83f803 7515 be???????? eb13 83f90a 7509 be???????? }
            // n = 7, score = 300
            //   83f803               | cmp                 eax, 3
            //   7515                 | jne                 0x17
            //   be????????           |                     
            //   eb13                 | jmp                 0x15
            //   83f90a               | cmp                 ecx, 0xa
            //   7509                 | jne                 0xb
            //   be????????           |                     

        $sequence_4 = { be???????? 8bca 3bc7 7302 8bce 030d???????? }
            // n = 6, score = 300
            //   be????????           |                     
            //   8bca                 | mov                 ecx, edx
            //   3bc7                 | cmp                 eax, edi
            //   7302                 | jae                 4
            //   8bce                 | mov                 ecx, esi
            //   030d????????         |                     

        $sequence_5 = { ffb5f8fbffff 8d85fcfbffff 50 89b5f4fbffff ffd7 }
            // n = 5, score = 300
            //   ffb5f8fbffff         | push                dword ptr [ebp - 0x408]
            //   8d85fcfbffff         | lea                 eax, [ebp - 0x404]
            //   50                   | push                eax
            //   89b5f4fbffff         | mov                 dword ptr [ebp - 0x40c], esi
            //   ffd7                 | call                edi

        $sequence_6 = { 8945fc 53 56 57 ff35???????? e8???????? 8b15???????? }
            // n = 7, score = 300
            //   8945fc               | mov                 dword ptr [ebp - 4], eax
            //   53                   | push                ebx
            //   56                   | push                esi
            //   57                   | push                edi
            //   ff35????????         |                     
            //   e8????????           |                     
            //   8b15????????         |                     

        $sequence_7 = { ff7534 e8???????? 837d3810 8bf8 8b4524 }
            // n = 5, score = 300
            //   ff7534               | push                dword ptr [ebp + 0x34]
            //   e8????????           |                     
            //   837d3810             | cmp                 dword ptr [ebp + 0x38], 0x10
            //   8bf8                 | mov                 edi, eax
            //   8b4524               | mov                 eax, dword ptr [ebp + 0x24]

        $sequence_8 = { 8d5dd8 50 ff75d8 8bc6 e8???????? a1???????? }
            // n = 6, score = 300
            //   8d5dd8               | lea                 ebx, [ebp - 0x28]
            //   50                   | push                eax
            //   ff75d8               | push                dword ptr [ebp - 0x28]
            //   8bc6                 | mov                 eax, esi
            //   e8????????           |                     
            //   a1????????           |                     

        $sequence_9 = { 8b4110 3bc6 7302 8bf0 8bc6 }
            // n = 5, score = 300
            //   8b4110               | mov                 eax, dword ptr [ecx + 0x10]
            //   3bc6                 | cmp                 eax, esi
            //   7302                 | jae                 4
            //   8bf0                 | mov                 esi, eax
            //   8bc6                 | mov                 eax, esi

    condition:
        7 of them and filesize < 204800
}

rule nemty_ransomware {

   meta:

      description= "Detect the risk of Ransomware Nemty Rule 3"
      hash = "73bf76533eb0bcc4afb5c72dcb8e7306471ae971212d05d0ff272f171b94b2d4"

   strings:

      $x1 = "/c vssadmin.exe delete shadows /all /quiet & bcdedit /set {default} bootstatuspolicy ignoreallfailures & bcdedit /set {default}" fullword ascii
      $s2 = "https://pbs.twimg.com/media/Dn4vwaRW0AY-tUu.jpg:large :D" fullword ascii
      $s3 = "MSDOS.SYS" fullword wide
      $s4 = "/c vssadmin.exe delete shadows /all /quiet & bcdedit /set {default} bootstatuspolicy ignoreallfailures & bcdedit /set {default} " ascii
      $s5 = "recoveryenabled no & wbadmin delete catalog -quiet & wmic shadowcopy delete" fullword ascii
      $s6 = "DECRYPT.txt" fullword ascii
      $s7 = "pv3mi+NQplLqkkJpTNmji/M6mL4NGe5IHsRFJirV6HSyx8mC8goskf5lXH2d57vh52iqhhEc5maLcSrIKbukcnmUwym+In1OnvHp070=" fullword ascii
      $s8 = "\\NEMTY-DECRYPT.txt\"" fullword ascii
      $s9 = "rfyPvccxgVaLvW9OOY2J090Mq987N9lif/RoIDP89luS9Ouv9gUImpgCTVGWvJzrqiS8hQ5El02LdEvKcJ+7dn3DxiXSNG1PwLrY59KzGs/gUvXnYcmT6t34qfZmr8g8" ascii
      $s10 = "IO.SYS" fullword wide
      $s11 = "QgzjKXcD1Jh/cOLBh1OMb+rWxUbToys2ArG9laNWAWk0rNIv2dnIDpc+mSbp91E8qVN8Mv8K5jC3EBr4TB8jh5Ns/onBhPZ9rLXR7wIkaXGeTZi/4/XOtO3DFiad4+vf" ascii
      $s12 = "NEMTY-DECRYPT.txt" fullword wide
      $s13 = "pvXmjPQRoUmjj0g9QZ24wvEqyvcJVvFWXc0LL2XL5DWmz8me5wElh/48FHKcpbnq8C2kwQ==" fullword ascii
      $s14 = "a/QRAGlNLvqNuONkUWCQTNfoW45DFkZVjUPn0t3tJQnHWPhJR2HWttXqYpQQIMpn" fullword ascii
      $s15 = "KeoJrLFoTgXaTKTIr+v/ObwtC5BKtMitXq8aaDT8apz98QQvQgMbncLSJWJG+bHvaMhG" fullword ascii
      $s16 = "pu/hj6YerUnqlUM9A8i+i/UhnvsIE+9XTYs=" fullword ascii
      $s17 = "grQkLxaGvL0IBGGCRlJ8Q4qQP/midozZSBhFGEDpNElwvWXhba6kTH1LoX8VYNOCZTDzLe82kUD1TSAoZ/fz+8QN7pLqol5+f9QnCLB9QKOi0OmpIS1DLlngr9YH99vt" ascii
      $s18 = "BOOTSECT.BAK" fullword wide
      $s19 = "bbVU/9TycwPO+5MgkokSHkAbUSRTwcbYy5tmDXAU1lcF7d36BTpfvzaV5/VI6ARRt2ypsxHGlnOJQUTH6Ya//Eu0jPi/6s2MmOk67csw/msiaaxuHXDostsSCC+kolVX" ascii
      $s20 = "puh4wXjVYWJzFN6aIgnClL4W/1/5Eg6bm5uEv6Dru0pfOvhmbF1SY3zav4RQVQTYMfZxAsaBYfJ+Gx+6gDEmKggypl1VcVXWRbxAuDIXaByh9aP4B2QvhLnJxZLe+AG5" ascii

   condition:
   
      ( uint16(0) == 0x5a4d and
      filesize < 400KB and
      ( 1 of ($x*) and
      4 of them ))
}

rule nemty_ransomware_2_6 {

   meta:
      description= "Detect the risk of Ransomware Nemty Rule 4"
      hash = "52b7d20d358d1774a360bb3897a889e14d416c3b2dff26156a506ff199c3388d"

   strings:
         
      $pattern = { 558B??83????53565789????29????6A??8D????8D????5A8B??89????8A????88????8B????8A????88??8A????88????8A??88????03??03??FF????75??89????8D????8D????8D????89????89????29????89????29????89????29????8D????8D????89????29????89????29????8B????89????29????8D????F6??????8B????8A????8B????8A????8A??88????8B????8A????88????75??0FB6??8A??????????0FB6??88????8A??????????0FB6????8A??????????88????0FB6????8A??????????88????8B????C1????32??????????8B????8A????32??8B????88????8A????32??88????8A??32????83????88????8B????8A????32????FF????88??83????83????83??????0F82????????5F5E5BC9C3558B??560FB6??57C1????03????6A??5F6A??5E8A??30??40414E75??4F75??5F5E5DC356576A??5F6A??8B??5E0FB6??8A??????????88??83????4E75??414F75??5F5EC38A????8A????88????8A????88????8A????88????8A????88????8A????88????8A????88????8A????88????8A????88????8A????88????8A????88????8A????88????88????C3558B??5153566A??83????5E8A????32??8A????8A????88????32??32??88????88????32??8A??C0????B3??F6??02??32??32????8A????32????32??88????8A??C0????F6??02??32??32????8A????32????88????8A??C0????F6??02??32??32??8A????32????32????88??8A??C0????F6??02??32??32????83????32????4E88????75??5E5BC9C3558B??53FF????8B??32??E8????????59B3??8B??E8????????8B??E8????????8B??E8????????FF????8B??8A??E8????????FE??5980????72??8B??E8????????8B??E8????????5B8B??B0??5DE9????????558B??81??????????A1????????33??89????8B????578D??????????89??????????E8????????33??6A??5839????76??5683????75??508D????5350E8????????8D??????????508D????E8????????83????6A??5880??????75??C6??????4879??EB??FE????33??8A??????8B??????????30????47403B????72??5E8B????33??5FE8????????C9C3558B??51515333??5633??32??89????39????0F86????????578B????8B????8A????8B??83????74??4F74??4F75??21????0FB6??0FB6??83????8B??C1????C1????0B??8A??????????83????88????8A??????????8B????88??????83????EB??0FB6??0FB6??83????6A??C1????C1????5E0B??EB??33??0FB6??46C1????8A??????????88????40FF????8A??8B????3B????72??5F4E74??4E75??0FB6??83????8A????????????88????C6????????83????EB??0FB6??83????C1????8A??????????88????66????????????83????5EC6??????5BC9C3558B??33??F6??????75??5733??39????76??8B????8A????80????74??80????7C??80????7F??0FB6??8A??????????80????74??8B??83????83????74??4A74??4A74??4A75??08????40EB??8A??C0????80????08????40C0????EB??8A??C0????80????08????40C0????EB??C0????88????473B????72??EB??33??5F5DC3558B??518B??85??74??8B????568B??89????3B??74??576A??33??E8????????83????3B????75??5FFF??E8????????595E33??89??89????89????C9C3558B??80??????74??83??????72??538B??85??74??575356E8????????83????53E8????????595BC7????????????89????C6??????5DC2????C7??????????E9????????558B??568B??C7??????????E8????????F6??????74??56E8????????598B??5E5DC2????558B??83????81??????????A1????????33??89????????????5356578D????508D??????E8????????68????????8D????????????E8????????6A??5F33??83????66????????8D????8B??33??5089??????89??????E8????????E8????????33??66????????8B????????????03??????83????8D??????89??????89??????E8????????538D??????5083????8D??????E8????????538D????????????5083????E8????????8B??8D??????E8????????6A??33??E8????????83????????8B??????73??8D??????8D????????????5150FF??????????89??????83????0F84????????8B??????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????68????????8D????????????50FF??85??0F84????????F6??????????????8D????????????508D??????8D??????74??E8????????598D??????51E8????????8B??598D??????E8????????6A??33??8D??????E8????????6A??8D??????E8????????83????8D??????8B??50E8????????E8????????83????E9????????E8????????8B??598D??????E8????????6A??33??8D??????E8????????8D????????????50FF??????????508D??????E8????????8B??????6A??5F39??????73??8D??????8B??????????68????????50FF??85??0F84????????8B??????39??????73??8D??????68????????50FF??85??0F84????????8B??????39??????73??8D??????68????????50FF??85??0F84????????8B??????39??????73??8D??????68????????50FF??85??0F84????????8B??????39??????73??8D??????68????????50FF??85??0F84????????8B??????39??????73??8D??????68????????50FF??85??0F84????????8B??????39??????73??8D??????68????????50FF??85??0F84????????8B??????39??????73??8D??????68????????50FF??85??0F84????????8B??????39??????73??8D??????68????????50FF??85??0F84????????8B??????39??????73??8D??????68????????50FF??85??0F84????????8B??????39??????73??8D??????68????????50FF??85??0F84????????8B??????39??????73??8D??????68????????50FF??85??0F84????????8B??????39??????73??8D??????68????????50FF??85??0F84????????8B??????39??????73??8D??????68????????50FF??85??0F84????????8B??????39??????73??8D??????68????????50FF??85??74??8B??????39??????73??8D??????68????????50FF??85??74??83????8B??68????????E8????????83????8D????????????8B??51E8????????E8????????83????85??75??8B??????39??????73??8D??????83????8B??51E8????????E8????????83????6A??33??8D??????E8????????8D????????????50FF??????FF??????????85??0F85????????FF??????FF??????????33??435333??8D?????? }


   condition:
   
      uint16(0) == 0x5a4d and
      filesize < 1500KB and
      $pattern
}

rule MANSORY_ransomware {
   meta:
      description= "Detect the risk of Ransomware Nemty Rule 5"
   strings:
      $s1 = "main.CTREncrypt" fullword ascii
      $s2 = "main.GenerateRandomBytes" fullword ascii
      $s3 = "idle: .MANSORY" ascii

   condition:
      uint16(0) == 0x5a4d and filesize < 400KB and 2 of them
}