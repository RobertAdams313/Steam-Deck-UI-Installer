-- Code.lua: Steam Deck ElvUI Installer with CVars and Plater Import

local format = string.format
local ReloadUI = ReloadUI
local StopMusic = StopMusic
local GetAddOnMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata

local addon, ns = ...
local Version = GetAddOnMetadata(addon, "Version")
local MyPluginName = "Steam Deck Installer"

local E, L, V, P, G = unpack(ElvUI)
local EP = LibStub("LibElvUIPlugin-1.0")
local mod = E:NewModule(MyPluginName, "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")

-- Default toggle settings
E.db["steamDeckInstaller"] = E.db["steamDeckInstaller"] or {
    disableBags = true,
}

-- Function to import ElvUI public profile from string
local function ImportElvUIProfile()
    local profileString = [[
!E1!LZ1AZPnsx6)k7xYw1wLZBXDBNVbyCm7ydmiLjBENk40iAanwOMrQXoE(q(TVNlTKADdizENzRD3QCzaP(YPpxEoN(CAPfnx4UWzLqlwkIIXVl)6EzKVm0tI)ATku74)hYftA2H)10d6a)q5cNPFW9(XtgTWzR0FZw9IjDx48I)k92ft60TXcNxNUEDSeU(BB3yHgAMkufrZqOyzGCXYSE2Sl1Ii5(dAH2xfIntl)Q(wv0obCN5JEOUz3mAdSgTwPesRoDWbw8hWsstlOKg1RHnHKBODVB8WFkz81y))Ol2vryO6aWx2jd14V3OuRw(Q0AjnaBSERi8jMvgcF10(L4Yl(quK0dxGUWIBHZB0IOns9BU4BFH713(YAve(d53(sK8p(2xE3)H9k0dAuOmahB)Wyno4lCgpXXT)KHJEC4D9HBSxePFDHZS(ZD)0cNyvGAHJtF4Rrc)vaNS)4B4fLEBKuODJeHXRL5fm89vQaT)EALSjsDy)4W1k8h7uRGPD40hM1FOl3wG5UJOk4Z7LpZKO1WbAv6iXy4UXdevmxEQDlfetL)w)azKU4y4fiIJVtgSph1s8CCT9Gi6jPrho3Gh)eWSWl)S)MqPw7hUPIgP88fezdmznjEko9W1neVroWZ1oLwwE82PoelN(mqQGCtCqRUZFftSWn)9dYyA8JFXx7TDWbTwfwKYD0hIchhwXq7h7HxnuDVsPNjqncZKSl16r45j3RhsCZ5jkEKvcqhFuffa8R99xRLrJcH)b8eUTytSu4uHR9J25Cy3oyyhKmSLgWbInvpwA((dJe4TXMVrStwuhWr7VJ4HIGxeVg78AmOPqQBqh0Va2pVER6qKHbWYRaQd2ix5HpcuHBqieJDJETFGUGIJtS(vEy8d9aJHyqT2X9t3pcaqwjlCfZ8MhE84dCHUIkP7Quj1reTtf9ktjX7rgBbfCWyxt9c)YDsXkZGujMOP93lwA0rRRv5mxRPrSMFKWZSi9dEMntaKLi3x3dn(N)q)7hdOn6C0mPPg6VtSNfhESMk899QiTGPmVdXGw7hr06FreCa8Z0QrpIJaAZmioT(tH7ClohbGnaE1T(WiX8qSVBtm3OFfPckcjzdmStgHM004e4ZMMHGEQXZhlbDul)ne8(zjGz69eZnoecscILzgtX6Nkk7oe6RxhbdhRLQcKJ9YBUBwkge3mdbWmcGZLeUjpwOchEFqRNv5Jrs0X1xdddC)v7Jbpa7yBx0gK4dodM6EhDBQZRrf4vXmxBL8XT(HSy3yn)OghoZvWjfn2d9iE7hcbCTvOn7)ugPWp)pLVid8qdCeyfUWda(KmiaK2agiEHHk1tM71hz0sq1zZR4p3OcwXca9wf4DsaWMHeVy2ZZWgmhDArMiBo4ZTLOWnaQ7QSvzLuE5fhIh4WMMtuSlyTIufnsGurflB9zBo2Lk8f1614qnoCLVNqRky0JJ(HiCSN6oFu)BidIvGp2Tv3HuSmbfsWsgu8z5wFpgvARs)Keq(cr(H73(cebceHWeruK6f7jEvKyJkCU)kdtoRFvBpZarHInSomQrAuV2)mP9T6Gb4isU5qGiYYqsgqOIjg4QNnaro3p6XBaWyYi)XMp(aEhsXZD6d3p6w3lgf88hgpduNd1xyD5wnUOj09dHXaG9CWgF7TaAOmYrkxb(jYnoxuyaUa6BliSZbhGqnnT0D6SstxY1A2OXfV9Qgi1(4nssMix9lmdV0CvMEHPRvBq)w8cnHdKbQxEGH4YM85JF)DUxyp18vEBRoxd)Rjm7duXXSp)Axyak4fT61BHd6I)wuJmBgkU0aY6T9aUW)ufk7V0pWhJ)R2XTbpU4yC7JO51EP(iSoljvNl617kqtmq8QmAgGHd6rhRRjxRvxyDd03nhIem5DQfuZRHUa7AWqLZK6HIy9YujuktTqhnC6oWFlCmYvhWaSSYy1RV2T7Hkt(p4VAvG8g9r55nkQ0FvEL(YuO91bISfkDJbq(qnycAnxffUT7cwi)8b5bjG7RpeFgkBalOzVg2I5MNPKQPHV3FWJDoh732nBCrBq62N3J1aBH0rmebvICKxRZOxe51dSaNNgP3GVdDIMDUeactCIxqh8y9TlQaJSLbtg5wGolrKWe1gPrW7ZAD)b1m4wmWMnA3(IRAX(6(GMmqE8m4gSwEF4AcoGWVtTVMDZSLFrgDUcodyZCCB0d3wW2QG(yHPStIaVFCmeL15H60SvNMxCzVofT26D(Uyitnx1(HsC7jO9MaCkgDelUUyhO9hxHcwnAxOi0GxrC18qw1Gh)2MDVawGasGCDz25rGQa(X7F4S59TA0g7X9kpYQ5u4AF0D4w7L(jOgWLsJwyVmodzFBq37dEZvNYTyxeHRDhucfTzlW0S9MFo8bMPFRYRmYy12ZTtuIhIzuOSIFzGNgnrRAm0wVi13PFOP)be)BWk1lHvSOQduThezdIQcscAhsJWSmydzDsgdjsOHh2C(zROWm0094MJ3uYkP11a(tGUm8rvrOCzkCVlL0RZJfs4nD6M3Y6CXPY6hPC8dedHzwpAesjxlvRYW0dF6Sf3wQXmZ57MfzMxWPDZZq3OtsJBD(UlAGHgzfXBfWOh3gV11xB7WV9jn6qq1UiUGia3(i6KRSfq1HPJH(asn097XAgAH587hGRwe56SwuxHb1NYlBFos6MqSeTtLvDpNUGby1aD0R9xd7u8m3NcnftMvYI506834soyZcdM)95nPMGUVxkEwMFlo1Qo2QzVlUIG)1YDMuRCEGCTaMjgO)0XdhXj)(y2N8QJTSkV7LJXxs2aZDyfmQ0RyDIUUw2A9otBnJ82Ltgufi3hXkffF(BW86nlsTjswW7wv4YnVSjhAvsWbpEee)eXurMWjjSwxMhG77clMq4UmZjaMoMZaqM3UagJmwnHtTNtAFwa7tUmFYeYZdGnrGnSfgkW5UXFch7AkrAQqO16zInucxCwk2WzbfZ61TzLARRvQzRl9pX7HnkGDggKMnmJ2vMpBB(SR5ZoMpV08zlZNxB(SzZKVKpJFj1FB8WPtO7ZeyNgyQHGLsSeZpb23C0B2YaZzKRAZgoHwIduMUUdRncMOQNLHRuyA9HHo8jopFWK8rU4DDB0WI1ufpaqAerWg8J82onCyGk2u0ctxQUIE4mykabL80jTUMN3WNSN4ClOAgPyViXEmzU40gVv9Ya)WvuoXhKS4EFK41IP6153oe(KPByMnLGxurAo4ZyE)E2w(P0qQI9PQBKQTXDOcoJjBDeAA2MLrQcVCFQioJdFgRj6aoN1l5Bbnw4d6ZZUV)Ngnpxg89cGirXa98EAvKAp2JadKrEzESNia)6)OvtUYo1j(8tsd(k)1R99oeWzz10)g)JRTlImOI6810FDzLSduZf6B4kw8M1cl0ikTLcFIDNnETSi7MwtBxAmPcpk4siK0SfMQpKXbQAjMCFozZ3n(MrPADOsMD3RtBvg6)0bFoT1KfsADKDafDkj4QCj14otjU7WZGsp3u9dSKg1qO0szJF4oWLbGoHc34Dqx3cbE1NtkpiqADfw5H8rJ5KWpkqf9n18CC4pjFf2ctwk5hbZye1ggdinnDPPj3OlH0)sfeeXoU0rCPYoejyLggPMtuEK)FGXJg4Sx4HzbFs7taDCm9YnW)1BVX3uR(foKIZJ3m9JtY6yM(EfO3ikpSuYihmTVSCh3g5lrMAVAuWsxivmuhDvSt81pcJvmOo9Dt2hJdubdTtnRkR1s2ISvp28WO8sIRApJjzLboubX46xzr8TochzTFzMDXX6B(cdV02ysNvoDaf8b8KnGhhKa0cI(vU5dmruy5DmvpnWU0PvAuLhDhv(5PEa5)weV1XlskdnJTF4dzMFLT7xbTFPseXvUlMksEHfRJw9KS8jjyFKAnmY(vCidY4nLp)baM1qSkVmAhjbXRXLm1aHQzN7PNqI8mmnE6s2tbeLuYOx8xbX)LOjSt8sLhiK0sIzk6TPo9WfAZHle1Z8zlZNnnF218zNKHkF5xnfPJT24GqtILJQ8RLcr8ZGMlZ)OnrXGoAH32KTpGYX9MVZGHWx1cWFt)H)07Np9dtUjRbjWYx3i7AMaoUKqb4dd0p2SOxuU(L5p7wPvZuJHAvuuttT9)XwShtStXMgAgDHgPr0VMlytWW5SnVkUSQK1sRmyhLfj53(YDcby88(iyhgXp9TVmaloSbv7)YGMbeLKSTq8ibLEXzkFCiWq(tPkKIM3)bJZw8y4eH1bFcMeFEa)eeQpbmEIOf1z8ERffgLPy3n(8HsiZfO5yNXN3nPia(HRvygnSJjHiynwDCSc2u4GUfwtCylK9aw7SsgkMJpHBIrz6z5iVW5oMsYrhODWJRnH3)RzbGrhRJp)Re02NTcec3)76tjR(nGC8x)6DPcR6pxD2hwMexsK6Zk)y8gpG7ra3B17daP9GuwBBmOGeDWCux(ve2eZAb)672jx5Fy3NRsaKad4MFsYoCIS0K)fotPAWHh2bktS33ZtB2kE2gvkSnmU8QTT6Es90IQ1jMjnBYQWglzRZQzgkDgljjcznFibArDPCSaDT1UZX3PEAzJxPuUCKkin)OzPJ9TQdmb7UYC6zYn26ubhfYyryRuLhWNRWtUYqbh2hptgnx9c4JJKGPIyY8DVnsy(BTgZMCbWS6fL2KVr5MZbsIMnFqmtoxkyWf2QKzIPufYgPRx(CZESfFom7sIQ864OiV9)NvKxaRCssebvJvMnqhhxb21FK(Z5mS)UakhoAIlUr7JGuAdBhN7ePDgAXPrUmxgxTtMSKjKTD4UPbY31APrJyD68vcCH(BZuGRbIQdJq9d5K1gW(e44TY2lVPvCyw3gP2XHVGQSuOv9dxLDSiXBX)AcY2jnkYK4YKrqUYehhEo2DmH768HXZ6phKUwwzewCvUYTneXn1nad8f3dBX4z0vdx83xyan(U0U)bcdOZIJggqQLEfcp6EZIWd2vs6Uk4TphFUGWRvJ2f5hEhI2V)Zf5Ju9oTHvRku48PNIN8VMLvPZnALugpJIEwXkEYqvkhCXjdlHxaXGrQfeEFe96MXtEFfXDFSWrmUAA(N2vZz7GX2xXrD2KQE9deXqXTpv2Ny(POIadQlQ3w2r9EcV475z)FLHquMBCo0sDsXFfug2cMv8g9bWsr(jlfGTtgvsiRjJn)8eLEQCT9iLQgo4d3ERtjv9CUJY5)HfBXVhLY0GYce6GdqcJLvf92sEjlcSqDCZhMIT1y5eO1Lnf8tSOZO)mZUtPCtAMdEfqBNE)O623zU4tYl1SGQmrJyRLwOT1QjyJuvb4NoVO8yXqW6W)iIcuFIoAzfmV01MIo(XyGOeAfhldKPopyojfXafiywYSmUsXAMPaaPionzWGerm7n0)xMlradaV2w5DzfRDynMSBLbMioO1KlLNTWKVBfxKHM0Mh0Ouid3fzhdDQcNWkfKDl0zCHACeJP6FaTyIz16aL3(aEFoA6XiGEaYOcDjwz25cDD8qJpaF2cSGdrbeg75u4IrjHPGn2tPWeycThq9L0dOdM8Z9iLLgba0B6GSFpLt04nznzDawY0cK(wnp)jkymoyUtvpL4qlM)slghjgPZQaNTS2ns)DQDAYvmoaOqWtUeF7KYInOeFoLoXNJMnYKtdgnTyElZtwNiF)ErQ6UPfjKB9WXbuC9C8hUaAIsE8P2l2yEM5g9lt)jC3k5u84Lm8JBIeVaw57LtdhslvtrUJMj1NlZVvJYS6gzRTYseRROnjg2TkEbiMU6mKRxvM3vyHUZCgajRZ6wgSkiLE6AAw5fsbHv26VkTRQvaI6E285kvkQJzyyE5OcaF4P(KngTBLSs5n6R(AZz)jpmm)uGA6tAdoYtRswPGXt)XX1yXZcGPG6iYsXzX628(jZv2HvCAWkSF4cc0KNQpc813ZiG7u9Oyh28zj(Jzf9mBTz9VVpeCnBSvl6tQ0uN4mgGD1M6BK6BlZTMl6uYfDrDBV2DVQrlypYTB3Px3RATy9B7IAf1DhoLdbu4VS3obkAm3iT(cMJoG7zMESZlVPNCpNzPROWopYT1gDfPc9s72WhfKJq1Se9VBI2kyE7q4ra6zPHAnDYG(ZpJz9ypS7PHZvkMWtoUAJLrkdM(fRRyQ9NB)5VFKB69QUL52lsrgbQ(zs9bznsG(3oFmSp07)0JtMnSGE3(iFydM0devaGEHL47cWikwfkcUy4qZP9QaloHa6LMSdy)xToA0tzr)YVjdGqL4ytZTtt7eSHWHb(6YP2mxAcItIiXwTSQffEKAPdopf13flr05jk8rUcLIxWhduQbx4Eishi5VJNdVbV(bW21w4FkrDnAh1WBSQdPTeLsIP1UvsuS7W6158DCMIbArqpC9jC1QsPzNsPfc6vHA5JZ0PTxYg(R7whtj9zioFEuH5y0KrpuLoBfzETekGn)OO6An0QfExL4g45bXvDhUKbu9RST9A93GsDTR6)YvkBDgkLD))xkLv6d)mXs)Fk93y1Hip5y8r8k6WEABL)yAW0ZqotKjPNDVhDXp)xJYrkhEN4Rji28Hf40a93a7ZgFy7Hz9hb0)VFZoRmE)5tygEe1)VRjnNbXPk2XVsv0JJXFTpF8mRNqnwnPrG8NXWr)V4Gqqw80WGxr43ZtZ)VkzU95q6KqT)z9))xFys)Vg9snfA9U9UkZ5mCaUzuSN8lULP)YO533Fg2kFVNC3gPoSHKf7nANj70xSkPmSC6XE2p238Mgazd07tKa674bgh3mBYR3I8NAWxurRWdSksiwuo6NsK8cvcFsyXdKhFMFDwGpq(PpTXMhgjSDbq74nhFVYBwWHySJ3G7Ua3u9q(jyWxYL8cBwHNFyMAXNWPfoVNE5Iygs(1pe2dZZ4rYuIJRl(MkchrRjGjE30u56rMC2j(iJ(tM)8Q3rKQVJZ)(9F7l3AE7SKqn41m0xc5IdzXNpld9D)ndE8gPw4dmtRWVwk0GYmwPGqZ7tL8CJUzCuRfwcLNtCKVJDQRJ5B2L5zy0t7mMj4BmV)Q4L5WKx0mPpo0hNFDmEuoEzj6PLT0p7ftrjvaDbdyRDkNCAxZRhRflRovwpjFf1(5ZSVJJ)oviSG3IQtuO3qp3Tp55T5nJF3BE4BF5n7)2xshYS5qUYxpq91SiG6paSKP3)BpoEId9qgqQK3LMq(gMRq16EEsfPsUA6Z0b9ekmaFzbzEHOrV1jmNkzUiijKk(4IfqwddWxpty22Fg4G4vIyqc6f)LA)RMKWHvoqc2haAaUu4rtS0HsnLkTibvYUzY0kVt3EzRgDVS71DB2SzVExFzpmfvTX6VC7vDU8Y2960OrNo9Ab3gVZLucVQ5olR7oOqgOFup8EGCI5CHNYxNxjZLp1jqxTEBoHplrdPhIc3f8J60GmFFdYIiU2SYSLEbpu487l)AHhva8jqI8R9HySkodQJzAElRbTEoqb0llkKc)5dcYgafu7ebbUfNa0CyX7EhEAY9dKV7Daji29VDJ07P)7d
    ]]
    if E.ImportProfile then
        E:ImportProfile(profileString)
        print("|cff4beb2cElvUI public profile 'SteamDeck' imported.|r")
    else
        print("|cffff0000Failed to import ElvUI public profile.|r")
    end
end

-- Function to import ElvUI private profile from string
local function ImportElvUIPrivateProfile()
    local privateProfileString = [[
!E1!LZ1AZPnsx6)k7xYw1wLZBXDBNVbyCm7ydmiLjBENk40iAanwOMrQXoE(q(TVNlTKADdizENzRD3QCzaP(YPpxEoN(CAPfnx4UWzLqlwkIIXVl)6EzKVm0tI)ATku74)hYftA2H)10d6a)q5cNPFW9(XtgTWzR0FZw9IjDx48I)k92ft60TXcNxNUEDSeU(BB3yHgAMkufrZqOyzGCXYSE2Sl1Ii5(dAH2xfIntl)Q(wv0obCN5JEOUz3mAdSgTwPesRoDWbw8hWsstlOKg1RHnHKBODVB8WFkz81y))Ol2vryO6aWx2jd14V3OuRw(Q0AjnaBSERi8jMvgcF10(L4Yl(quK0dxGUWIBHZB0IOns9BU4BFH713(YAve(d53(sK8p(2xE3)H9k0dAuOmahB)Wyno4lCgpXXT)KHJEC4D9HBSxePFDHZS(ZD)0cNyvGAHJtF4Rrc)vaNS)4B4fLEBKuODJeHXRL5fm89vQaT)EALSjsDy)4W1k8h7uRGPD40hM1FOl3wG5UJOk4Z7LpZKO1WbAv6iXy4UXdevmxEQDlfetL)w)azKU4y4fiIJVtgSph1s8CCT9Gi6jPrho3Gh)eWSWl)S)MqPw7hUPIgP88fezdmznjEko9W1neVroWZ1oLwwE82PoelN(mqQGCtCqRUZFftSWn)9dYyA8JFXx7TDWbTwfwKYD0hIchhwXq7h7HxnuDVsPNjqncZKSl16r45j3RhsCZ5jkEKvcqhFuffa8R99xRLrJcH)b8eUTytSu4uHR9J25Cy3oyyhKmSLgWbInvpwA((dJe4TXMVrStwuhWr7VJ4HIGxeVg78AmOPqQBqh0Va2pVER6qKHbWYRaQd2ix5HpcuHBqieJDJETFGUGIJtS(vEy8d9aJHyqT2X9t3pcaqwjlCfZ8MhE84dCHUIkP7Quj1reTtf9ktjX7rgBbfCWyxt9c)YDsXkZGujMOP93lwA0rRRv5mxRPrSMFKWZSi9dEMntaKLi3x3dn(N)q)7hdOn6C0mPPg6VtSNfhESMk899QiTGPmVdXGw7hr06FreCa8Z0QrpIJaAZmioT(tH7ClohbGnaE1T(WiX8qSVBtm3OFfPckcjzdmStgHM004e4ZMMHGEQXZhlbDul)ne8(zjGz69eZnoecscILzgtX6Nkk7oe6RxhbdhRLQcKJ9YBUBwkge3mdbWmcGZLeUjpwOchEFqRNv5Jrs0X1xdddC)v7Jbpa7yBx0gK4dodM6EhDBQZRrf4vXmxBL8XT(HSy3yn)OghoZvWjfn2d9iE7hcbCTvOn7)ugPWp)pLVid8qdCeyfUWda(KmiaK2agiEHHk1tM71hz0sq1zZR4p3OcwXca9wf4DsaWMHeVy2ZZWgmhDArMiBo4ZTLOWnaQ7QSvzLuE5fhIh4WMMtuSlyTIufnsGurflB9zBo2Lk8f1614qnoCLVNqRky0JJ(HiCSN6oFu)BidIvGp2Tv3HuSmbfsWsgu8z5wFpgvARs)Keq(cr(H73(cebceHWeruK6f7jEvKyJkCU)kdtoRFvBpZarHInSomQrAuV2)mP9T6Gb4isU5qGiYYqsgqOIjg4QNnaro3p6XBaWyYi)XMp(aEhsXZD6d3p6w3lgf88hgpduNd1xyD5wnUOj09dHXaG9CWgF7TaAOmYrkxb(jYnoxuyaUa6BliSZbhGqnnT0D6SstxY1A2OXfV9Qgi1(4nssMix9lmdV0CvMEHPRvBq)w8cnHdKbQxEGH4YM85JF)DUxyp18vEBRoxd)Rjm7duXXSp)Axyak4fT61BHd6I)wuJmBgkU0aY6T9aUW)ufk7V0pWhJ)R2XTbpU4yC7JO51EP(iSoljvNl617kqtmq8QmAgGHd6rhRRjxRvxyDd03nhIem5DQfuZRHUa7AWqLZK6HIy9YujuktTqhnC6oWFlCmYvhWaSSYy1RV2T7Hkt(p4VAvG8g9r55nkQ0FvEL(YuO91bISfkDJbq(qnycAnxffUT7cwi)8b5bjG7RpeFgkBalOzVg2I5MNPKQPHV3FWJDoh732nBCrBq62N3J1aBH0rmebvICKxRZOxe51dSaNNgP3GVdDIMDUeactCIxqh8y9TlQaJSLbtg5wGolrKWe1gPrW7ZAD)b1m4wmWMnA3(IRAX(6(GMmqE8m4gSwEF4AcoGWVtTVMDZSLFrgDUcodyZCCB0d3wW2QG(yHPStIaVFCmeL15H60SvNMxCzVofT26D(Uyitnx1(HsC7jO9MaCkgDelUUyhO9hxHcwnAxOi0GxrC18qw1Gh)2MDVawGasGCDz25rGQa(X7F4S59TA0g7X9kpYQ5u4AF0D4w7L(jOgWLsJwyVmodzFBq37dEZvNYTyxeHRDhucfTzlW0S9MFo8bMPFRYRmYy12ZTtuIhIzuOSIFzGNgnrRAm0wVi13PFOP)be)BWk1lHvSOQduThezdIQcscAhsJWSmydzDsgdjsOHh2C(zROWm0094MJ3uYkP11a(tGUm8rvrOCzkCVlL0RZJfs4nD6M3Y6CXPY6hPC8dedHzwpAesjxlvRYW0dF6Sf3wQXmZ57MfzMxWPDZZq3OtsJBD(UlAGHgzfXBfWOh3gV11xB7WV9jn6qq1UiUGia3(i6KRSfq1HPJH(asn097XAgAH587hGRwe56SwuxHb1NYlBFos6MqSeTtLvDpNUGby1aD0R9xd7u8m3NcnftMvYI506834soyZcdM)95nPMGUVxkEwMFlo1Qo2QzVlUIG)1YDMuRCEGCTaMjgO)0XdhXj)(y2N8QJTSkV7LJXxs2aZDyfmQ0RyDIUUw2A9otBnJ82Ltgufi3hXkffF(BW86nlsTjswW7wv4YnVSjhAvsWbpEee)eXurMWjjSwxMhG77clMq4UmZjaMoMZaqM3UagJmwnHtTNtAFwa7tUmFYeYZdGnrGnSfgkW5UXFch7AkrAQqO16zInucxCwk2WzbfZ61TzLARRvQzRl9pX7HnkGDggKMnmJ2vMpBB(SR5ZoMpV08zlZNxB(SzZKVKpJFj1FB8WPtO7ZeyNgyQHGLsSeZpb23C0B2YaZzKRAZgoHwIduMUUdRncMOQNLHRuyA9HHo8jopFWK8rU4DDB0WI1ufpaqAerWg8J82onCyGk2u0ctxQUIE4mykabL80jTUMN3WNSN4ClOAgPyViXEmzU40gVv9Ya)WvuoXhKS4EFK41IP6153oe(KPByMnLGxurAo4ZyE)E2w(P0qQI9PQBKQTXDOcoJjBDeAA2MLrQcVCFQioJdFgRj6aoN1l5Bbnw4d6ZZUV)Ngnpxg89cGirXa98EAvKAp2JadKrEzESNia)6)OvtUYo1j(8tsd(k)1R99oeWzz10)g)JRTlImOI6810FDzLSduZf6B4kw8M1cl0ikTLcFIDNnETSi7MwtBxAmPcpk4siK0SfMQpKXbQAjMCFozZ3n(MrPADOsMD3RtBvg6)0bFoT1KfsADKDafDkj4QCj14otjU7WZGsp3u9dSKg1qO0szJF4oWLbGoHc34Dqx3cbE1NtkpiqADfw5H8rJ5KWpkqf9n18CC4pjFf2ctwk5hbZye1ggdinnDPPj3OlH0)sfeeXoU0rCPYoejyLggPMtuEK)FGXJg4Sx4HzbFs7taDCm9YnW)1BVX3uR(foKIZJ3m9JtY6yM(EfO3ikpSuYihmTVSCh3g5lrMAVAuWsxivmuhDvSt81pcJvmOo9Dt2hJdubdTtnRkR1s2ISvp28WO8sIRApJjzLboubX46xzr8TochzTFzMDXX6B(cdV02ysNvoDaf8b8KnGhhKa0cI(vU5dmruy5DmvpnWU0PvAuLhDhv(5PEa5)weV1XlskdnJTF4dzMFLT7xbTFPseXvUlMksEHfRJw9KS8jjyFKAnmY(vCidY4nLp)baM1qSkVmAhjbXRXLm1aHQzN7PNqI8mmnE6s2tbeLuYOx8xbX)LOjSt8sLhiK0sIzk6TPo9WfAZHle1Z8zlZNnnF218zNKHkF5xnfPJT24GqtILJQ8RLcr8ZGMlZ)OnrXGoAH32KTpGYX9MVZGHWx1cWFt)H)07Np9dtUjRbjWYx3i7AMaoUKqb4dd0p2SOxuU(L5p7wPvZuJHAvuuttT9)XwShtStXMgAgDHgPr0VMlytWW5SnVkUSQK1sRmyhLfj53(YDcby88(iyhgXp9TVmaloSbv7)YGMbeLKSTq8ibLEXzkFCiWq(tPkKIM3)bJZw8y4eH1bFcMeFEa)eeQpbmEIOf1z8ERffgLPy3n(8HsiZfO5yNXN3nPia(HRvygnSJjHiynwDCSc2u4GUfwtCylK9aw7SsgkMJpHBIrz6z5iVW5oMsYrhODWJRnH3)RzbGrhRJp)Re02NTcec3)76tjR(nGC8x)6DPcR6pxD2hwMexsK6Zk)y8gpG7ra3B17daP9GuwBBmOGeDWCux(ve2eZAb)672jx5Fy3NRsaKad4MFsYoCIS0K)fotPAWHh2bktS33ZtB2kE2gvkSnmU8QTT6Es90IQ1jMjnBYQWglzRZQzgkDgljjcznFibArDPCSaDT1UZX3PEAzJxPuUCKkin)OzPJ9TQdmb7UYC6zYn26ubhfYyryRuLhWNRWtUYqbh2hptgnx9c4JJKGPIyY8DVnsy(BTgZMCbWS6fL2KVr5MZbsIMnFqmtoxkyWf2QKzIPufYgPRx(CZESfFom7sIQ864OiV9)NvKxaRCssebvJvMnqhhxb21FK(Z5mS)UakhoAIlUr7JGuAdBhN7ePDgAXPrUmxgxTtMSKjKTD4UPbY31APrJyD68vcCH(BZuGRbIQdJq9d5K1gW(e44TY2lVPvCyw3gP2XHVGQSuOv9dxLDSiXBX)AcY2jnkYK4YKrqUYehhEo2DmH768HXZ6phKUwwzewCvUYTneXn1nad8f3dBX4z0vdx83xyan(U0U)bcdOZIJggqQLEfcp6EZIWd2vs6Uk4TphFUGWRvJ2f5hEhI2V)Zf5Ju9oTHvRku48PNIN8VMLvPZnALugpJIEwXkEYqvkhCXjdlHxaXGrQfeEFe96MXtEFfXDFSWrmUAA(N2vZz7GX2xXrD2KQE9deXqXTpv2Ny(POIadQlQ3w2r9EcV475z)FLHquMBCo0sDsXFfug2cMv8g9bWsr(jlfGTtgvsiRjJn)8eLEQCT9iLQgo4d3ERtjv9CUJY5)HfBXVhLY0GYce6GdqcJLvf92sEjlcSqDCZhMIT1y5eO1Lnf8tSOZO)mZUtPCtAMdEfqBNE)O623zU4tYl1SGQmrJyRLwOT1QjyJuvb4NoVO8yXqW6W)iIcuFIoAzfmV01MIo(XyGOeAfhldKPopyojfXafiywYSmUsXAMPaaPionzWGerm7n0)xMlradaV2w5DzfRDynMSBLbMioO1KlLNTWKVBfxKHM0Mh0Ouid3fzhdDQcNWkfKDl0zCHACeJP6FaTyIz16aL3(aEFoA6XiGEaYOcDjwz25cDD8qJpaF2cSGdrbeg75u4IrjHPGn2tPWeycThq9L0dOdM8Z9iLLgba0B6GSFpLt04nznzDawY0cK(wnp)jkymoyUtvpL4qlM)slghjgPZQaNTS2ns)DQDAYvmoaOqWtUeF7KYInOeFoLoXNJMnYKtdgnTyElZtwNiF)ErQ6UPfjKB9WXbuC9C8hUaAIsE8P2l2yEM5g9lt)jC3k5u84Lm8JBIeVaw57LtdhslvtrUJMj1NlZVvJYS6gzRTYseRROnjg2TkEbiMU6mKRxvM3vyHUZCgajRZ6wgSkiLE6AAw5fsbHv26VkTRQvaI6E285kvkQJzyyE5OcaF4P(KngTBLSs5n6R(AZz)jpmm)uGA6tAdoYtRswPGXt)XX1yXZcGPG6iYsXzX628(jZv2HvCAWkSF4cc0KNQpc813ZiG7u9Oyh28zj(Jzf9mBTz9VVpeCnBSvl6tQ0uN4mgGD1M6BK6BlZTMl6uYfDrDBV2DVQrlypYTB3Px3RATy9B7IAf1DhoLdbu4VS3obkAm3iT(cMJoG7zMESZlVPNCpNzPROWopYT1gDfPc9s72WhfKJq1Se9VBI2kyE7q4ra6zPHAnDYG(ZpJz9ypS7PHZvkMWtoUAJLrkdM(fRRyQ9NB)5VFKB69QUL52lsrgbQ(zs9bznsG(3oFmSp07)0JtMnSGE3(iFydM0devaGEHL47cWikwfkcUy4qZP9QaloHa6LMSdy)xToA0tzr)YVjdGqL4ytZTtt7eSHWHb(6YP2mxAcItIiXwTSQffEKAPdopf13flr05jk8rUcLIxWhduQbx4Eishi5VJNdVbV(bW21w4FkrDnAh1WBSQdPTeLsIP1UvsuS7W6158DCMIbArqpC9jC1QsPzNsPfc6vHA5JZ0PTxYg(R7whtj9zioFEuH5y0KrpuLoBfzETekGn)OO6An0QfExL4g45bXvDhUKbu9RST9A93GsDTR6)YvkBDgkLD))xkLv6d)mXs)Fk93y1Hip5y8r8k6WEABL)yAW0ZqotKjPNDVhDXp)xJYrkhEN4Rji28Hf40a93a7ZgFy7Hz9hb0)VFZoRmE)5tygEe1)VRjnNbXPk2XVsv0JJXFTpF8mRNqnwnPrG8NXWr)V4Gqqw80WGxr43ZtZ)VkzU95q6KqT)z9))xFys)Vg9snfA9U9UkZ5mCaUzuSN8lULP)YO533Fg2kFVNC3gPoSHKf7nANj70xSkPmSC6XE2p238Mgazd07tKa674bgh3mBYR3I8NAWxurRWdSksiwuo6NsK8cvcFsyXdKhFMFDwGpq(PpTXMhgjSDbq74nhFVYBwWHySJ3G7Ua3u9q(jyWxYL8cBwHNFyMAXNWPfoVNE5Iygs(1pe2dZZ4rYuIJRl(MkchrRjGjE30u56rMC2j(iJ(tM)8Q3rKQVJZ)(9F7l3AE7SKqn41m0xc5IdzXNpld9D)ndE8gPw4dmtRWVwk0GYmwPGqZ7tL8CJUzCuRfwcLNtCKVJDQRJ5B2L5zy0t7mMj4BmV)Q4L5WKx0mPpo0hNFDmEuoEzj6PLT0p7ftrjvaDbdyRDkNCAxZRhRflRovwpjFf1(5ZSVJJ)oviSG3IQtuO3qp3Tp55T5nJF3BE4BF5n7)2xshYS5qUYxpq91SiG6paSKP3)BpoEId9qgqQK3LMq(gMRq16EEsfPsUA6Z0b9ekmaFzbzEHOrV1jmNkzUiijKk(4IfqwddWxpty22Fg4G4vIyqc6f)LA)RMKWHvoqc2haAaUu4rtS0HsnLkTibvYUzY0kVt3EzRgDVS71DB2SzVExFzpmfvTX6VC7vDU8Y2960OrNo9Ab3gVZLucVQ5olR7oOqgOFup8EGCI5CHNYxNxjZLp1jqxTEBoHplrdPhIc3f8J60GmFFdYIiU2SYSLEbpu487l)AHhva8jqI8R9HySkodQJzAElRbTEoqb0llkKc)5dcYgafu7ebbUfNa0CyX7EhEAY9dKV7Daji29VDJ07P)7d
    ]]
    if E.ImportPrivateProfile then
        E:ImportPrivateProfile(privateProfileString)
        print("|cff4beb2cElvUI private profile 'SteamDeck' imported.|r")
    else
        print("|cffff0000Failed to import ElvUI private profile.|r")
    end
end

-- Function to import Plater profile from string
local function ImportPlaterProfile()
    if not Plater then
        print("|cffff0000Plater is not loaded.|r")
        return
    end

    local exportString = [[
^1^SPlaterDatabase^T^SsavedRevision^S54102^Sversion^SPlater-v54102-3-g7ac9ac3^Sprofiles^T^SSteamDeckPlater^T...
    ]]

    if Plater.ImportProfileFromString then
        Plater.ImportProfileFromString(exportString)
        print("|cff4beb2cPlater profile imported. Please /reload.|r")
    else
        print("|cffff0000Unable to import Plater profile.|r")
    end
end

-- Disable ElvUI bags if a conflicting addon is detected
local function DisableElvUIBagModule()
    if not E.db["steamDeckInstaller"].disableBags then return end

    local bagAddons = {"Baganator", "Bagnon", "AdiBags", "ArkInventory", "Inventorian", "Combuctor"}
    for _, addonName in ipairs(bagAddons) do
        if IsAddOnLoaded(addonName) or _G[addonName] then
            print(format("|cffff0000%s detected. Disabling ElvUI bags module.|r", addonName))
            E.private.bags.enable = false
            return
        end
    end

    -- Prefer ConsoleBags if present
    if IsAddOnLoaded("ConsoleBags") or _G["ConsoleBags"] then
        print("|cffff9900ConsoleBags detected. Disabling ElvUI bags module to ensure compatibility.|r")
        E.private.bags.enable = false
        return
    end
end

-- Apply ConsolePort settings if loaded
local function ApplyConsolePortTweaks()
    if not IsAddOnLoaded("ConsolePort") then return end

    -- Example tweak: widen unitframe clickable area for gamepad navigation
    if E.db.unitframe then
        E.db.unitframe.targetOnMouseDown = true
        E.db.unitframe.smartRaidFilter = false
    end

    -- Optional CVars or ElvUI settings optimized for ConsolePort users
    SetCVar("autoInteract", 1)
    print("|cff4beb2cConsolePort detected. Applying controller-friendly tweaks.|r")
end

-- Setup layout and apply settings
local function SetupLayout()
    E.data:SetProfile("SteamDeck")
    ImportElvUIProfile()
    ImportElvUIPrivateProfile()

    -- Detect and handle bag addon conflicts
    DisableElvUIBagModule()

    -- ConsolePort tweaks
    ApplyConsolePortTweaks()

    -- Apply E.private settings
    E.private["actionbar"]["masque"]["actionbars"] = true
    E.private["actionbar"]["masque"]["petBar"] = true
    E.private["actionbar"]["masque"]["stanceBar"] = true

    -- Import Plater
    ImportPlaterProfile()

    print("|cff4beb2cSteam Deck Layout Applied|r")
end

-- Add a config panel to ElvUI options
local function InsertOptions()
    E.Options.args[MyPluginName] = {
        order = 100,
        type = "group",
        name = format("|cff4beb2c%s|r", MyPluginName),
        args = {
            header1 = {
                order = 1,
                type = "header",
                name = "Steam Deck Installer",
            },
            description1 = {
                order = 2,
                type = "description",
                name = "This addon installs the Steam Deck layout for ElvUI and imports a Plater profile.",
            },
            installButton = {
                order = 4,
                type = "execute",
                name = "Reinstall Layout",
                desc = "Re-run the layout installer for this character.",
                func = function()
                    E:GetModule("PluginInstaller"):Queue(InstallerData)
                    E:ToggleOptions()
                end,
            },
            importPlater = {
                order = 5,
                type = "execute",
                name = "Reimport Plater Profile",
                desc = "Manually re-import the Plater profile if needed.",
                func = function()
                    ImportPlaterProfile()
                end,
            },
            toggleHeader = {
                order = 6,
                type = "header",
                name = "Conflict Detection Settings",
            },
            disableBags = {
                order = 7,
                type = "toggle",
                name = "Auto-disable Bags Module",
                get = function() return E.db.steamDeckInstaller.disableBags end,
                set = function(_, val) E.db.steamDeckInstaller.disableBags = val end,
            },
            version = {
                order = 20,
                type = "description",
                name = function()
                    return format("Addon Version: |cffffd200%s|r", Version or "unknown")
                end,
            },
        },
    }
end

-- Installer steps
local InstallerData = {
    Title = "Steam Deck UI Installer",
    Name = "Steam Deck Installer",
    Pages = {
        [1] = function()
            return {
                Title = "Welcome",
                Description = "This installer will apply the Steam Deck optimized layout and import a Plater profile.",
            }
        end,
        [2] = function()
            return {
                Title = "Apply Layout",
                Description = "Click 'Apply' to set up your ElvUI layout for Steam Deck.",
                OnAccept = function()
                    SetupLayout()
                end,
            }
        end,
        [3] = function()
            return {
                Title = "Import Plater Profile",
                Description = "Click 'Import' to import the recommended Plater profile.",
                OnAccept = function()
                    ImportPlaterProfile()
                end,
            }
        end,
        [4] = function()
            return {
                Title = "Finished",
                Description = "Setup complete! You may need to /reload your UI.",
            }
        end,
    },
    StepTitles = {
        "Welcome",
        "Apply Layout",
        "Import Plater",
        "Finished"
    },
}

function mod:Initialize()
    EP:RegisterPlugin(addon, InsertOptions)

    -- Register slash command
    SLASH_SDUI1 = "/sdui"
    SlashCmdList["SDUI"] = function(msg)
        msg = msg:lower()
        if msg == "install" then
            if E:GetModule("PluginInstaller") then
                E:GetModule("PluginInstaller"):Queue(InstallerData)
            end
        else
            print("|cff4beb2cSteam Deck UI|r: Type |cffffd200/sdui install|r to reinstall the layout.")
        end
    end
end

E:RegisterModule(mod:GetName())