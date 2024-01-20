import 'package:coinxfiat/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/utils_index.dart';

Widget htmlView(BuildContext context, String html) => HtmlWidget(
      html,
      buildAsync: true,
      enableCaching: true,
      renderMode: RenderMode.column,
      onTapUrl: (link) async {
        Uri uri = Uri.parse(link);
        if (await canLaunchUrl(uri)) {
          launchUrl(uri);
        } else {
          toast('Could not launch $link');
        }
        return true;
      },
      textStyle: getTheme(context).textTheme.bodyLarge,
    );

///common html viewer page with custom appbar and title
class HtmlPage extends StatelessWidget {
  const HtmlPage({Key? key, this.html, this.title}) : super(key: key);
  final String? html;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title ?? '')),
      body: ListView(
        padding: const EdgeInsetsDirectional.all(DEFAULT_PADDING),
        children: [htmlView(context, html ?? dataNotFoundHTML)],
      ),
    );
  }
}

String dataNotFoundHTML = r'''
<div class="row justify-content-center">
  <div class="col-lg-7 text-center mx-auto">
    <img src="https://arthurmaurice.com/assets/errors/images/error-404.png" alt="image">
    <h2 class="title"><b></b> Data not found</h2>
    <p>Data you are looking for doesn't exist or another error occurred <br> or is temporarily unavailable.</p>
  </div>
</div>
''';
String setupWalletHTML = r'''
<div  padding: 30px; border-radius: 10px; --darkreader-inline-bgimage: initial; --darkreader-inline-bgcolor: #000000;" data-darkreader-inline-bgimage="" data-darkreader-inline-bgcolor="">
            <div class="row justify-content-between ">
                <!-- <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/join now.png" alt="step-2" class="img-fluid"> -->
                <div class="pt-3 pb-3">
                    <h3 class="title text-start">Trust Wallet Setup</h3>
                    <h5 class="title text-start pt-2">CoinxFiat BUSD registration</h5>
                </div>
                <div class="pt-4 store-link">
                    <h5 class="title text-start"><b>Download Trust Wallet</b></h5>
                    <p class="pt-2" style="font-size:18px;">Choose your device type and download the
                        application:</p>
                    <div class="pt-2">
                        <a href="https://play.google.com/store/apps/details?id=com.wallet.crypto.trustapp&amp;referrer=utm_source%3Dwebsite" target="_blank">Google Play (Android)</a><br><br>
                        <a href="https://apps.apple.com/app/apple-store/id1288339409?mt=8" target="_blank">AppStore (iOS)</a>
                    </div>
                </div>
                <!-- install the app -->
                <div class="pt-5">
                    <h5 class="title text-start"><b>Install and setup</b></h5>
                    <ul>
                        <li>open wallet application and select <span>"Create a new wallet"</span></li>
                        <li>Confirm checkbox with Terms of Service and press <span>"Continue"</span></li>
                        <li>Read closely warnings about you <span>Secret Recovery Phrase,</span> this will help to keep
                            your crypto safe</li>
                        <li>Check all boxes and press <span>"Continue"</span></li>
                        <div class="install-image pt-4 pb-3">
                            <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/TRUSTM123.jpg" alt="step-2" class="img-fluid">
                        </div>
                        <li>Wallet application will offer you to save your <span> Secret Recovery Phrase (12
                                words)</span> and then input it in proper order</li>
                        <div class="pt-4 alert-box alert alert-error">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-triangle icon" style="color: red; --darkreader-inline-stroke: currentColor; --darkreader-inline-color: #ff2727;" data-darkreader-inline-stroke="" data-darkreader-inline-color=""><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
                            <div>
                                <p><span>Secret Recovery Phrase </span> is generated only once - during your wallet
                                    address
                                    creation process.</p>
                                <p><span>Secret Recovery Phrase </span> is the only way to keep safe and recover your
                                    wallet
                                    any time.</p>
                                <p>Never share <span>Secret Recovery Phrase </span> with anyone under any circumstances
                                    -
                                    this will give lifetime access to your wallet for that person.</p>
                            </div>
                        </div>
                        <li>Confirm your successful wallet creation and you will see your assets list</li>
                        <div class=" alert-box alert alert-success pt-4">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-check-circle icon" style="color: green; --darkreader-inline-stroke: currentColor; --darkreader-inline-color: #abffab;" data-darkreader-inline-stroke="" data-darkreader-inline-color=""><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                            <p>Now you need to add BUSD Token and BNB Coin display</p>
                        </div>
                        <li>Click on token finder icon on the <span>top right side</span></li>
                        <div class="install-image pt-4 pb-3">
                            <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/wallet-image.jpg" alt="step-2" class="img-fluid">
                        </div>
                        <li>Type <span>bnb</span> in search bar and click on checkbox to add <span>BNB Smart
                                Chain</span> coin</li>
                        <li>Type <span>busd </span> in search bar and click on checkbox to add <span>Binance-Peg BUSD
                                (BEP20)</span> token</li>
                        <div class=" alert-box alert alert-danger">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(240, 185, 11); --darkreader-inline-stroke: currentColor; --darkreader-inline-color: #ffff39;" data-darkreader-inline-stroke="" data-darkreader-inline-color=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                            <p>There may be similar token names, make sure you adding proper - double check when you
                                select <span>BNB Smart Chain and Binance-Peg BUSD (BEP20)</span></p>
                        </div>
                        <li>Click back icon and you will see newly added tokens in your assets list</li>
                        <div class="install-image pt-4 pb-3">
                            <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/wallet-image2.jpg" alt="step-2" class="img-fluid">
                        </div>
                    </ul>

                </div>
                <!-- How to copy wallet address -->
                <div class="pt-5">
                    <h5 class="title text-start"><b>How to copy wallet address</b></h5>
                    <ul>
                        <li>Click on <span>Binance-Peg BUSD</span> Token to enter its properties</li>
                        <li>To copy your crypto address that you need to fund with BUSD or BNB click on
                            <span>"Receive"</span> icon
                        </li>
                        <li>Copy the code of address for next operations</li>
                    </ul>
                    <div class=" alert-box alert alert-blue">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(52, 109, 219); --darkreader-inline-stroke: currentColor; --darkreader-inline-color: #69daff;" data-darkreader-inline-stroke="" data-darkreader-inline-color=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                        <p>Your BNB and BUSD will be located on same crypto address in blockchain - so you can copy it
                            only once and use to purchase both BNB and BUSD.</p>
                    </div>
                    <div class="install-image pt-4 pb-3">
                        <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/copy-address-img.jpg" alt="step-2" class="img-fluid">
                    </div>
                </div>

            </div>
        </div>
''';

String zebpayHTML = '''
<div style="padding:11px;">
                <div class="row justify-content-between ">
                    <!-- <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/join now.png" alt="step-2" class="img-fluid"> -->
                    <div class="pt-3 pb-3"  border-radius: 10px; padding: 10px 20px; --darkreader-inline-bgimage: initial; --darkreader-inline-bgcolor: #000000;" data-darkreader-inline-bgimage="" data-darkreader-inline-bgcolor="">
                        <h3 class="title text-start">ZebPay Exchange</h3>
                        <p class="pt-2">ZebPay is a crypto-assets exchange with an established presence in India,
                            Australia,
                            and Singapore. The choice of millions of traders, ZebPay offers its services across a wide
                            range of devices, including mobile apps for those who are always on the go and a seamless
                            web interface for users who prefer desktops</p>
                    </div>
                    <div class=" alert-box alert alert-blue">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(52, 109, 219); --darkreader-inline-color: #69daff; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                        <p>Download and install the ZebPay Exchange. <a href="https://zebpay.com/in/apps" target="_blank">(Download)</a></p>
                    </div>
                    <!-- The entire process involves 6 steps: -->
                    <div  border-radius: 10px; padding: 20px; --darkreader-inline-bgimage: initial; --darkreader-inline-bgcolor: #000000;" data-darkreader-inline-bgimage="" data-darkreader-inline-bgcolor="">
                        <h5><span>The entire process involves 6 steps:</span></h5>
                        <div class="account-step">
                            <p>1.</p>
                            <a href="#account registration">Account Registration</a>
                        </div>
                        <div class="account-step">
                            <p>2.</p>
                            <a href="#Identity Verification (KYC)">Identity Verification (KYC)</a>
                        </div>
                        <div class="account-step">
                            <p>3.</p>
                            <a href="#Bank Verification">Bank Verification</a>
                        </div>
                        <div class="account-step">
                            <p>4.</p>
                            <a href="#Depositing Funds (INR)">Depositing Funds (INR)</a>
                        </div>
                        <div class="account-step">
                            <p>5.</p>
                            <a href="#Purchasing BNB/BUSD">Purchasing BNB/BUSD</a>
                        </div>
                        <div class="account-step">
                            <p>6.</p>
                            <a href="#Withdrawing BNB/BUSD to Personal Wallet">Withdrawing BNB/BUSD to Personal Wallet</a>
                        </div>
                    </div>

                    <!-- Account Registration -->
                    <div class="mt-4"  border-radius: 10px; padding: 20px; --darkreader-inline-bgimage: initial; --darkreader-inline-bgcolor: #000000;" id="account registration" data-darkreader-inline-bgimage="" data-darkreader-inline-bgcolor="">
                        <h4 class="title text-start"><b>1. Account Registration</b></h4>
                        <ul>
                            <li>Open the ZebPay application after successful installation.</li>
                            <li>Click on the <span>Let’s go</span> option at the top right corner.</li>
                            <li>Choose the <span>country code.</span></li>
                            <li>Enter a valid <span>phone number.</span></li>
                            <li>Enter the <span>first name</span> and <span> lase name.</span></li>
                            <li>Enter a valid <span>email address.</span></li>
                            <li>You can enter a promotional/referral code if any.</li>
                            <li>Create a 4-digit <span>PIN.</span></li>
                            <li><span>Confirm </span> the PIN Code.</li>

                            <!-- Attention -->
                            <div class="mt-5 alert-box alert alert-error">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-triangle icon" style="color: red; --darkreader-inline-color: #ff2727; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
                                <div>
                                    <h5 class="title text-start">ATTENTION!</h5>
                                    <p>Do not share the 4-digit PIN code under any circumstances. The code is exclusive
                                        only to
                                        you. The code never gets stored by ZebPay or anyone else.</p>
                                </div>
                            </div>

                            <li>Accept the Terms of Use and Privacy Policy of ZebPay by putting a <span>check </span> in
                                the checkbox.</li>
                            <div class=" alert-box alert alert-blue">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(52, 109, 219); --darkreader-inline-color: #69daff; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                <p>Your BNB and BUSD will be located on same crypto address in blockchain - so you can
                                    copy
                                    it
                                    only once and use to purchase both BNB and BUSD.</p>
                            </div>

                            <li>Click <span>Continue</span></li>
                            <li>You will receive a verification code to your registered mobile number and email address.
                                Enter the code in the respective fields and click <span>Continue</span></li>
                            <!-- Image -->
                            <div class="install-image pt-4 pb-3">
                                <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/wallet-image3.webp" alt="step-2" class="img-fluid">
                            </div>
                            <!-- alert -->
                            <div class=" alert-box alert alert-success">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-check-circle icon" style="color: green; --darkreader-inline-color: #abffab; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                <p>Your mobile number and email address are verified.</p>
                            </div>

                            <li>You will get redirected to the login portal.
                                Enter the registered <span>mobile number.</span> </li>
                            <li>Accept the Terms of Use and Privacy Policy of ZebPay by putting a <span>check </span>
                                in the checkbox.</li>
                            <li>Click <span>Proceed Securely.</span></li>
                            <li>Enter the <span>OTP</span> sent to your mobile number.</li>
                            <li>Tap <span>Verify.</span></li>
                            <li>Now enter your 4-digit <span>PIN </span> code to log into your account.</li>

                            <!-- Image -->
                            <div class="install-image pt-4 pb-3">
                                <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/wallet-image4.webp" alt="step-2" class="img-fluid">
                            </div>
                            <!-- alert Box -->
                            <div class=" alert-box alert alert-success">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-check-circle icon" style="color: green; --darkreader-inline-color: #abffab; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                <p>Your mobile number and email address are verified.</p>
                            </div>

                        </ul>


                    </div>

                    <!-- Identity Verification (KYC) -->
                    <div class="mt-4"  border-radius: 10px; padding: 20px; --darkreader-inline-bgimage: initial; --darkreader-inline-bgcolor: #000000;" id="Identity Verification (KYC)" data-darkreader-inline-bgimage="" data-darkreader-inline-bgcolor="">
                        <h4 class="title text-start"><b>2. Identity Verification (KYC)</b></h4>
                        <div>
                            <ul>
                                <li>Once you have logged in to your account, click on the <span>three horizontal
                                        lines</span> on the top left of the screen.</li>
                                <li>Go to the <span>Verify Identity (KYC)</span> section to proceed with the
                                    verification process.</li>
                                <!-- Image -->
                                <div class="install-image pt-4 pb-3">
                                    <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/wallet-image-background-remove.webp" alt="step-2" class="img-fluid">
                                </div>
                                <div class="pt-3">
                                    <h6>The KYC verification process gets completed in three steps:</h6>
                                </div>
                                <!-- Document Proof -->
                                <div class="pt-3">
                                    <h6 class="title text-start" style="color: rgb(255, 255, 255); --darkreader-inline-color: #ffffff;" data-darkreader-inline-color=""><b>A] Document Proof -</b>
                                    </h6>
                                    <ul style="list-style:disc;">
                                        <li>Upload a clear image of your <span>PAN Card.</span></li>
                                        <li>You can choose to click a picture using the camera or upload an existing
                                            image from your gallery.</li>
                                        <li>Once the upload is successful, click <span>Continue</span></li>
                                    </ul>
                                    <!-- Image -->
                                    <div class="install-image pt-4 pb-3">
                                        <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/wallet-image-5.webp" alt="step-2" class="img-fluid">
                                    </div>
                                    <!-- alert box -->
                                    <div class=" alert-box alert alert-success">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-check-circle icon" style="color: green; --darkreader-inline-color: #abffab; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                        <p>You will get redirected to the next section- <span>Address Proof</span></p>
                                    </div>
                                </div>

                                <!-- Address Proof  -->
                                <div class="pt-3">
                                    <h6 class="title text-start" style="color: rgb(255, 255, 255); --darkreader-inline-color: #ffffff;" data-darkreader-inline-color=""><b>B ] Address Proof -</b>
                                    </h6>
                                    <ul style="list-style:disc;">
                                        <li>Upload a clear image of any one of the documents mentioned below:</li>
                                        <ol>
                                            <li><span>Aadhaar Card</span></li>
                                            <li><span>Driving Licence</span></li>
                                            <li><span>Passport Utility Bill </span> (within the last three months)</li>
                                        </ol>

                                    </ul>
                                    <h6 class="pt-3">You can upload any one of these documents as address proof.</h6>
                                    <ul style="list-style:disc;">
                                        <li>Once the upload is successful, click <span>Continue</span></li>
                                    </ul>
                                    <!-- Image -->
                                    <div class="install-image pt-4 pb-3">
                                        <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/wallet-image-6.webp" alt="step-2" class="img-fluid">
                                    </div>
                                    <!-- alert box -->
                                    <div class=" alert-box alert alert-success">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-check-circle icon" style="color: green; --darkreader-inline-color: #abffab; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                        <p>You will get redirected to the next section- <span>Declaration</span></p>
                                    </div>
                                </div>

                                <!-- Declaration   -->
                                <div class="pt-3">
                                    <h6 class="title text-start" style="color: rgb(255, 255, 255); --darkreader-inline-color: #ffffff;" data-darkreader-inline-color=""><b>C ] Declaration -</b>
                                    </h6>
                                    <ul style="list-style:disc;">
                                        <li>Here you need to choose the <span>source of funds </span> and
                                            <span>occupation</span>
                                        </li>
                                        <li>Once you enter the choices, click <span>Continue</span></li>

                                    </ul>
                                    <!-- Image -->
                                    <div class="install-image pt-4 pb-3">
                                        <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/wallet-image7.webp" alt="step-2" class="img-fluid">
                                    </div>
                                    <!-- alert box -->
                                    <div class=" alert-box alert alert-success">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-check-circle icon" style="color: green; --darkreader-inline-color: #abffab; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                        <p>Your KYC documents will get verified, and you will receive a successful
                                            verification notification.</p>
                                    </div>
                                </div>


                            </ul>
                        </div>
                    </div>

                    <!-- Bank Verification -->
                    <div class="mt-4"  border-radius: 10px; padding: 20px; --darkreader-inline-bgimage: initial; --darkreader-inline-bgcolor: #000000;" id="Bank Verification" data-darkreader-inline-bgimage="" data-darkreader-inline-bgcolor="">
                        <h4 class="title text-start"><b>3. Bank Verification</b></h4>
                        <h6 class="pt-2">It is mandatory to complete the Bank Verification process to make fiat deposits
                            and withdrawals.</h6>
                        <ul>
                            <li>Click on the <span>three horizontal lines</span> on the top left of the screen and go to
                                <span>Bank &amp; UPI.</span>
                            </li>
                            <li>Enter the following details:</li>
                            <ol>
                                <li><span>Account Holder’s Name</span></li>
                                <li><span>Full Bank Name</span></li>
                                <li><span>Account Number </span> (confirm the account number)</li>
                                <li><span>IFSC Code</span></li>
                            </ol>
                            <li>You need to upload the proof of your bank account ownership displaying the
                                above-mentioned information.</li>
                            <li>You can upload any one of the following documents:</li>
                            <ol>
                                <li><span>Canceled Cheque</span></li>
                                <li><span>Bank Statement</span></li>
                                <li><span>First Page of Passbook</span></li>
                            </ol>
                            <!-- alert box -->
                            <div class=" alert-box alert alert-danger">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(240, 185, 11); --darkreader-inline-color: #ffff39; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>

                                <div>
                                    <h5 class="title text-start">IMPORTANT!</h5>
                                    <ul style="list-style:disc">
                                        <li>The name and date of birth on the ID and address proof should match.</li>
                                        <li>You can create an account in ZebPay only if your age is 18 years and above.
                                        </li>
                                        <li>The name on your ID proof (pan card) should match with the bank account you
                                            wish to register with ZebPay.</li>
                                        <li>Please ensure to update the information accurately and upload clear
                                            documents for quick verifications.</li>
                                    </ul>
                                </div>
                            </div>
                            <li>Click on <span>Save bank details.</span></li>

                        </ul>
                        <!-- Image -->
                        <div class="install-image pt-4 pb-3">
                            <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/wallet-image8.webp" alt="step-2" class="img-fluid">
                        </div>
                        <!-- alert box -->
                        <div class=" alert-box alert alert-success">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-check-circle icon" style="color: green; --darkreader-inline-color: #abffab; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                            <p>Your Bank Documents will get verified within 7 business days.</p>
                        </div>
                    </div>


                    <!-- Depositing Funds (INR) -->
                    <div class="mt-4"  border-radius: 10px; padding: 20px; --darkreader-inline-bgimage: initial; --darkreader-inline-bgcolor: #000000;" id="Depositing Funds (INR)" data-darkreader-inline-bgimage="" data-darkreader-inline-bgcolor="">
                        <h4 class="title text-start"><b>4. Depositing Funds (INR)</b></h4>
                        <h6 class="pt-2">You can deposit INR rupees into your ZebPay Account using the Instant Deposit
                            option via NEFT, RTGS, or IMPS.</h6>

                        <!-- alert box -->
                        <div class=" alert-box alert alert-error">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-triangle icon" style="color: red; --darkreader-inline-color: #ff2727; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>

                            <div>
                                <h5 class="title text-start">ATTENTION!</h5>
                                <ul style="list-style:disc">
                                    <li>You can only make deposits through the banking application associated with the
                                        registered bank account in ZebPay.</li>
                                    <li>You cannot use UPI to make a deposit. UPI deposits will fail and will get
                                        refunded within three weeks. ZebPay will not be responsible for the loss of
                                        funds sent via UPI.
                                    </li>

                                </ul>
                            </div>
                        </div>
                        <ul>
                            <li>In your ZebPay application, go to the <span>Portfolio </span>section</li>
                            <li>Tap on the <span>Deposit </span>option and choose <span>Instant Deposit.</span></li>
                            <!-- Image -->
                            <div class="install-image pt-4 pb-3">
                                <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/wallet-image9.webp" alt="step-2" class="img-fluid">
                            </div>
                            <li>In the next interface, a unique beneficiary account will be displayed exclusively for
                                your deposits.</li>
                            <li>Use the banking application to make a deposit into the beneficiary account.</li>
                            <!-- Image -->
                            <div class="install-image pt-4 pb-3">
                                <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/wallet-image10.webp" alt="step-2" class="img-fluid">
                            </div>
                        </ul>

                        <!-- alert box -->
                        <div class=" alert-box alert alert-danger">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(240, 185, 11); --darkreader-inline-color: #ffff39; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>

                            <div>
                                <h5 class="title text-start">IMPORTANT!</h5>
                                <ul style="list-style:disc">
                                    <li>IMPS deposits get credited within 5 minutes, and NEFT and RTGS deposits are as
                                        per regular banking norms</li>
                                    <li>Do not deposit via UPI. These transactions will fail, and funds might get lost.
                                    </li>
                                    <li>Deposits made into incorrect beneficiary accounts will be treated as third-party
                                        transfers and get refunded with a Rs 500 penalty deducted.</li>
                                    <li>The beneficiary account displayed in your application is unique only to you and
                                        is not to be shared with anyone else.</li>
                                </ul>
                            </div>
                        </div>


                    </div>

                    <!-- Purchasing BNB/BUSD -->
                    <div class="mt-4"  border-radius: 10px; padding: 20px; --darkreader-inline-bgimage: initial; --darkreader-inline-bgcolor: #000000;" id="Purchasing BNB/BUSD" data-darkreader-inline-bgimage="" data-darkreader-inline-bgcolor="">
                        <h4 class="title text-start"><b>5. Purchasing BNB/BUSD</b></h4>

                        <!-- alert box -->
                        <div class=" alert-box alert alert-blue">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(52, 109, 219); --darkreader-inline-color: #69daff; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                            <p>In ZebPay, BNB is referred to as Binance Coin, and BUSD is referred to as Binance USD.
                            </p>
                        </div>
                        <ul>
                            <li>In your application, go to the <span>Exchange </span>section</li>
                            <li>Search for <span>BNB </span>or <span>BUSD </span> using the search bar provided on the
                                top and choose the coin.</li>
                            <!-- Image -->
                            <div class="install-image pt-4 pb-3">
                                <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/wallet-image-rem1.jpg" alt="step-2" class="img-fluid">
                            </div>
                            <li>In the <span>Buy </span> section, enter the <span>amount </span>of INR you want to spend
                                to purchase BNB or BUSD.</li>
                            <li>Keep the <span>price limit</span> exactly the same as the market price.</li>
                            <li>Click on the <span>Buy</span> option</li>
                            <li>Click <span>confirm trade</span> and enter the <span>PIN</span> code if asked.</li>
                            <!-- Image -->
                            <div class="install-image pt-4 pb-3">
                                <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/wallet-image11.webp" alt="step-2" class="img-fluid">
                            </div>
                        </ul>

                        <!-- alert -->
                        <div class=" alert-box alert alert-success">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-check-circle icon" style="color: green; --darkreader-inline-color: #abffab; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                            <p>Your trade will be executed, and the corresponding amount in BNB or BUSD will be credited
                                into your ZebPay account.</p>
                        </div>
                    </div>


                    <!-- Withdrawing BNB/BUSD to Personal Wallet -->
                    <div class="mt-4"  border-radius: 10px; padding: 20px; --darkreader-inline-bgimage: initial; --darkreader-inline-bgcolor: #000000;" id="Withdrawing BNB/BUSD to Personal Wallet" data-darkreader-inline-bgimage="" data-darkreader-inline-bgcolor="">
                        <h4 class="title text-start"><b>6. Withdrawing BNB/BUSD to Personal Wallet</b></h4>
                        <ul>
                            <li>In your ZebPay application, go to the<span>Exchange </span>section</li>
                            <li>Select BNB/BUSD from the list.</li>
                            <li>Click on the <span>Send </span> option</li>
                            <li>Tap <span></span> + Add new address.</li>

                            <!-- alert Attention -->
                            <div class="mt-5 alert-box alert alert-error">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-triangle icon" style="color: red; --darkreader-inline-color: #ff2727; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
                                <div>
                                    <h5 class="title text-start">ATTENTION!</h5>
                                    <p>You can send BUSD only to a BSC (BEP-20) network address as ZebPay only supports
                                        the purchase of BUSD over the BEP-20 network. Sending BUSD to a wallet address
                                        with a different network can result in a loss of funds.</p>
                                </div>
                            </div>

                            <!-- Image -->
                            <div class="install-image pt-4 pb-3">
                                <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/wallet-image12.webp" alt="step-2" class="img-fluid">
                            </div>
                            <!-- danger alert box -->
                            <div class=" alert-box alert alert-danger">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(240, 185, 11); --darkreader-inline-color: #ffff39; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>

                                <div>
                                    <h5 class="title text-start">NOTE:</h5>
                                    <p>ZebPay only supports BNB in BEP-2 format. If you are purchasing BNB from ZebPay,
                                        make sure you withdraw it to a BNB (BEP-2) wallet address and not BSC (BEP-20)
                                        wallet address. You can later swap the BNB inside the wallet application.</p>
                                </div>
                            </div>

                            <ul style="list-style:disc">
                                <li>Enter the following details:</li>
                                <ol>
                                    <li><span>Address Label</span> or <span>Nickname</span></li>
                                    <li><span>Recipient Address</span></li>
                                    <li><span>Beneficiary’s Full Name</span></li>
                                    <li><span>Beneficiary’s Platform</span></li>
                                </ol>
                                <li class="pt-2">Tap <span>SAVE ADDRESS.</span></li>
                            </ul>
                            <!-- Image -->
                            <div class="install-image pt-4 pb-3">
                                <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/wallet-image-13-rem.jpg" alt="step-2" class="img-fluid">
                            </div>
                            <li>Now enter the <span>Quantity </span> you want to transfer or tap on <span>Send
                                    All</span> if you wish to transfer all the crypto.</li>
                            <li>Tap on the <span>send icon</span> to initiate your transaction.</li>
                            <li>Enter the 4-digit <span>PIN </span> or use the <span>fingerprint/FaceID,</span> and
                                enter the <span>OTP </span> to confirm the transaction.</li>
                        </ul>
                        <!-- Image -->
                        <div class="install-image pt-4 pb-3">
                            <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/wallet-image-14-rem.jpg" alt="step-2" class="img-fluid">
                        </div>

                        <!-- alert -->
                        <div class=" alert-box alert alert-success">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-check-circle icon" style="color: green; --darkreader-inline-color: #abffab; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                            <p>The transaction will be processed shortly and you will receive a success notification.
                                <br>
                                <span>Congratulations!</span> Your wallet address has been funded successfully.
                            </p>

                        </div>
                    </div>

                </div>
            </div>
''';

String binanceHTML = '''
<div style="padding:11px;">
                <div class="row justify-content-between ">
                    <!-- <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/join now.png" alt="step-2" class="img-fluid"> -->
                    <div class="pt-3 pb-3" border-radius: 10px; padding: 10px 20px; --darkreader-inline-bgimage: initial; --darkreader-inline-bgcolor: #000000;" data-darkreader-inline-bgimage="" data-darkreader-inline-bgcolor="">
                        <h3 class="title text-start">Binance Exchange</h3>
                        <p class="pt-2">Binance Exchange is the world’s largest exchange in terms of the daily
                            trading volume of cryptocurrencies. It hosts over 600+ cryptocurrencies as a means of
                            buying, selling, and trading.</p>
                    </div>
                    <div class=" alert-box alert alert-blue">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(52, 109, 219); --darkreader-inline-color: #69daff; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                        <p>Download and install the Binance Exchange. <a href="https://www.binance.com/en/download" target="_blank">(Download)</a></p>
                    </div>
                    <!-- The entire process involves 6 steps: -->
                    <div border-radius: 10px; padding: 20px; --darkreader-inline-bgimage: initial; --darkreader-inline-bgcolor: #000000;" data-darkreader-inline-bgimage="" data-darkreader-inline-bgcolor="">
                        <h5><span>The entire process involves 6 steps:</span></h5>
                        <div class="account-step">
                            <p>1.</p>
                            <a href="#Registration of Account">Registration of Account</a>
                        </div>
                        <div class="account-step">
                            <p>2.</p>
                            <a href="#Personal Verification Process">Personal Verification Process</a>
                        </div>
                        <div class="account-step">
                            <p>3.</p>
                            <a href="#Identity Verification Process (KYC)">Identity Verification Process (KYC)</a>
                        </div>
                        <div class="account-step">
                            <p>4.</p>
                            <a href="#Add Payment Methods">Add Payment Methods</a>
                        </div>
                        <div class="account-step">
                            <p>5.</p>
                            <a href="#Purchase of BNB/BUSD">Purchase of BNB/BUSD</a>
                        </div>
                        <div class="account-step">
                            <p>6.</p>
                            <a href="#Withdraw BNB/BUSD to personal wallet">Withdraw BNB/BUSD to personal wallet</a>
                        </div>
                    </div>

                    <!-- Registration of Account-->
                    <div class="mt-4" border-radius: 10px; padding: 20px; --darkreader-inline-bgimage: initial; --darkreader-inline-bgcolor: #000000;" id="Registration of Account" data-darkreader-inline-bgimage="" data-darkreader-inline-bgcolor="">
                        <h4 class="title text-start"><b>1. Registration of Account</b></h4>
                        <h6 class="pt-3">Open the Binance application. </h6>
                        <h6 class="title text-start pt-3" style="color: rgb(255, 255, 255); --darkreader-inline-color: #ffffff;" data-darkreader-inline-color="">Registration of account can be done via
                            three methods:</h6>
                        <!-- Using Phone Number -->
                        <div>
                            <h6 class="title text-start pt-3" style="color: rgb(255, 255, 255); --darkreader-inline-color: #ffffff;" data-darkreader-inline-color="">1. Using Phone Number</h6>
                            <ul>
                                <li>Tap <span>Sign up with phone or email.</span></li>
                                <!-- Image -->
                                <div class="install-image pt-4 pb-3">
                                    <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image1.webp" alt="step-2" class="img-fluid">
                                </div>
                                <li>Choose the country code.</li>
                                <li>Enter the <span>phone number.</span></li>
                                <li>Set a <span>password</span></li>
                                <li>Enter <span>Referral ID, </span> if any. </li>
                                <li>Put a <span>check</span> against the T&amp;C and Privacy Policy. </li>
                                <li>Tap <span>Create Account.</span></li>
                                <!-- alert box -->
                                <div class=" alert-box alert alert-success">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-check-circle icon" style="color: green; --darkreader-inline-color: #abffab; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                    <p>Slide down the puzzle to complete Security Verification, if asked.</p>
                                </div>
                                <h6>A verification code will be sent to the entered phone number. </h6>
                                <li>Enter the <span>code. </span></li>
                                <li>Tap <span>Submit.</span></li>
                            </ul>
                        </div>

                        <!--  Using Email Address -->
                        <div>
                            <h6 class="title text-start pt-3" style="color: rgb(255, 255, 255); --darkreader-inline-color: #ffffff;" data-darkreader-inline-color="">2. Using Email Address</h6>
                            <ul>
                                <li>Tap <span>Sign up with phone or email.</span></li>
                                <!-- Image -->
                                <div class="install-image pt-4 pb-3">
                                    <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image2.webp" alt="step-2" class="img-fluid">
                                </div>
                                <li>Enter a <span>valid email. </span></li>
                                <li>Set a <span>password.</span></li>
                                <li>Enter <span>Referral ID,</span> if any. </li>
                                <li>Put a <span>check </span> against the T&amp;C and Privacy Policy. </li>
                                <li>Tap <span>Create Account.</span></li>
                                <!-- alert box -->
                                <div class=" alert-box alert alert-success">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-check-circle icon" style="color: green; --darkreader-inline-color: #abffab; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                    <p>Slide down the puzzle to complete Security Verification, if asked.</p>
                                </div>
                                <h6>A verification code will be sent to the entered email address. </h6>
                                <li>Enter the <span>code. </span></li>
                                <li>Tap <span>Submit.</span></li>
                            </ul>
                        </div>

                        <!--  Using Google Account-->
                        <div>
                            <h6 class="title text-start pt-3" style="color: rgb(255, 255, 255); --darkreader-inline-color: #ffffff;" data-darkreader-inline-color="">3. Using Google Account</h6>
                            <ul>
                                <li>Tap <span> Continue with Google.</span></li>
                                <!-- Image -->
                                <div class="install-image pt-4 pb-3">
                                    <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image3.webp" alt="step-2" class="img-fluid">
                                </div>
                                <li><span>Choose an account </span> from the listed accounts. <br>(opt for Add another
                                    account if no suitable account has already been listed)</li>
                                <h6 class="pt-2">Read the contents of 'Terms and Conditions.'</h6>
                                <!-- Image -->
                                <div class="install-image pt-4 pb-3">
                                    <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image4.webp" alt="step-2" class="img-fluid">
                                </div>
                                <li>Tap <span>Agree and share.</span></li>
                                <li>Put a <span>check</span> against the T&amp;C and Privacy Policy. </li>
                                <li>Enter the <span>Referral ID, </span> if any. </li>
                                <li>Tap <span>Confirm</span></li>
                                <h6 class="pt-4">Click <span>Verify Now</span> to proceed with the next Verification
                                    process.</h6>
                                <!-- alert box -->
                                <div class=" alert-box alert alert-success">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-check-circle icon" style="color: green; --darkreader-inline-color: #abffab; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                    <p>Slide down the puzzle to complete Security Verification, if asked.</p>
                                </div>
                                <h6>A verification code will be sent to the entered email address. </h6>
                                <li>Enter the <span>code. </span></li>
                                <li>Tap <span>Submit.</span></li>
                            </ul>
                        </div>


                    </div>


                    <!--  Personal Verification Process-->
                    <div class="mt-4" border-radius: 10px; padding: 20px; --darkreader-inline-bgimage: initial; --darkreader-inline-bgcolor: #000000;" id="Personal Verification Process" data-darkreader-inline-bgimage="" data-darkreader-inline-bgcolor="">
                        <h4 class="title text-start"><b>2. Personal Verification Process</b></h4>

                        <!-- Verification of ‘Country of Residence -->
                        <div>
                            <h6 class="title text-start pt-3" style="color: rgb(255, 255, 255); --darkreader-inline-color: #ffffff;" data-darkreader-inline-color="">1. Verification of ‘Country of
                                Residence'</h6>
                            <!-- Image -->
                            <div class="install-image pt-4 pb-3">
                                <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image5.webp" alt="step-2" class="img-fluid">
                            </div>
                            <ul>
                                <li>Tap the <span>downward arrow.</span></li>

                                <li><span>Search</span> for the country name. </li>
                                <li>Choose your <span>country.</span></li>
                                <li>Press<span>Continue.</span></li>
                            </ul>
                        </div>

                        <!--   Verification of 'Identity Information' -->
                        <div>
                            <h6 class="title text-start pt-3" style="color: rgb(255, 255, 255); --darkreader-inline-color: #ffffff;" data-darkreader-inline-color="">2. Verification of 'Identity
                                Information'</h6>
                            <ul>
                                <li>Choose <span>Nationality.</span></li>
                                <!-- Image -->
                                <div class="install-image pt-4 pb-3">
                                    <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image6.webp" alt="step-2" class="img-fluid">
                                </div>
                                <li>Enter the required details:</li>
                                <ol>
                                    <li>Full Name/First Name </li>
                                    <li>Last Name</li>
                                    <li>Middle Name</li>
                                    <li>Date of Birth</li>
                                </ol>
                                <!-- danger alert box -->
                                <div class=" alert-box alert alert-danger">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(240, 185, 11); --darkreader-inline-color: #ffff39; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                    <p><span>NOTE:</span> Name and DOB should be the same as on the official documents.
                                        <br>
                                        If found erroneous, further KYC process will be <span>rejected</span> and the
                                        account will not be verified.
                                    </p>
                                </div>
                                <li>Tap <span>Continue.</span></li>
                            </ul>
                        </div>

                        <!--  Verification of 'Additional Information'-->
                        <div>
                            <h6 class="title text-start pt-3" style="color: rgb(255, 255, 255); --darkreader-inline-color: #ffffff;" data-darkreader-inline-color="">4. Verification of 'Additional
                                Information'</h6>

                            <!-- Image -->
                            <div class="install-image pt-4 pb-3">
                                <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image7.webp" alt="step-2" class="img-fluid">
                            </div>
                            <ul>
                                <li>Enter the required details:</li>
                                <ol>
                                    <li>Residential Address </li>
                                    <li>Pin/Postal Code</li>
                                    <li>City</li>
                                    <li>Add the rest details, if asked for any.</li>
                                </ol>
                                <li>Tap <span>Continue.</span></li>
                                <!-- alert box -->
                                <div class=" alert-box alert alert-blue">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(52, 109, 219); --darkreader-inline-color: #69daff; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                    <p>Details will be added and KYC process will start for authentication of the user.
                                    </p>
                                </div>
                            </ul>
                        </div>


                    </div>

                    <!-- Identity Verification Process (KYC) -->
                    <div class="mt-4" border-radius: 10px; padding: 20px; --darkreader-inline-bgimage: initial; --darkreader-inline-bgcolor: #000000;" id="Identity Verification Process (KYC)" data-darkreader-inline-bgimage="" data-darkreader-inline-bgcolor="">
                        <h4 class="title text-start"><b>3. Identity Verification Process (KYC)</b></h4>
                        <!-- Verification of official documents -->
                        <div>
                            <h6 class="title text-start pt-3" style="color: rgb(255, 255, 255); --darkreader-inline-color: #ffffff;" data-darkreader-inline-color="">1. Verification of official documents
                            </h6>
                            <h6 class="pt-2">This process requires an official government-issued document - National ID,
                                Passport, or
                                Driver’s License.</h6>
                            <!-- Image -->
                            <div class="install-image pt-4 pb-3">
                                <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image8.webp" alt="step-2" class="img-fluid">
                            </div>
                            <ul>
                                <li>Select the <span>country/region</span> (where the document was issued).</li>
                                <li>Choose an appropriate option as per the government-issued document.
                                    (National ID Card/Passport/Driver’s License, etc) </li>
                                <li>Click <span>Continue</span></li>
                                <h6>Read the instructions very carefully.</h6>
                                <li>Tap <span>Continue</span></li>
                                <h6 class="pt-3">Document verification is done by uploading the images.</h6>

                                <!-- Image -->
                                <div class="install-image pt-4 pb-3">
                                    <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image-9.webp" alt="step-2" class="img-fluid">
                                </div>
                                <li>Click <span>Add.</span></li>
                                <li>Press <span>Take photo. </span></li>
                                <h6 class="pt-3">Upload an image of your documents. </h6>
                                <!-- alert box -->
                                <div class=" alert-box alert alert-danger">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(240, 185, 11); --darkreader-inline-color: #ffff39; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>

                                    <div>
                                        <p><span>NOTE: </span> You will be asked to upload images of the front side and
                                            back side of the document in case of National IDs. </p>
                                        <p>Images should be clear. The contents of the image such as name, address,
                                            identification code, etc should be visible.</p>
                                        <p><span>KYC process can get rejected if the uploads are not verifiable. </span>
                                        </p>
                                    </div>
                                </div>
                                <li>Tap <span>OK </span> and <span>Continue</span></li>
                            </ul>
                        </div>

                        <!-- Verification via Selfie -->
                        <div>
                            <h6 class="title text-start pt-3" style="color: rgb(255, 255, 255); --darkreader-inline-color: #ffffff;" data-darkreader-inline-color="">2. Verification via Selfie
                            </h6>
                            <h6 class="pt-2">This process verifies the identity with the help of an on-spot image of the
                                front face.</h6>
                            <!-- Image -->
                            <div class="install-image pt-4 pb-3">
                                <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image10.webp" alt="step-2" class="img-fluid">
                            </div>
                            <ul>
                                <li>Press <span>Take a Selfie. </span></li>
                                <li>Capture a clear image.</li>
                                <li>Click <span>Continue</span></li>
                                <!-- alert box -->
                                <div class=" alert-box alert alert-danger">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(240, 185, 11); --darkreader-inline-color: #ffff39; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>

                                    <div>
                                        <p><span>NOTE: </span> The selfie must be clear. </p>
                                        <p>Do not wear glasses or any materials that cover the face. No head wears
                                            allowed. </p>
                                        <p>The photo must be taken in a well-lit environment. </p>
                                        <p><span>Verification can be rejected if the selfie is not proper. </span>
                                        </p>
                                    </div>
                                </div>
                            </ul>
                        </div>

                        <!-- Facial Verification-->
                        <div>
                            <h6 class="title text-start pt-3" style="color: rgb(255, 255, 255); --darkreader-inline-color: #ffffff;" data-darkreader-inline-color="">3. Facial Verification
                            </h6>
                            <h6 class="pt-2">This is a live verification of the face.</h6>
                            <!-- Image -->
                            <div class="install-image pt-4 pb-3">
                                <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image11.webp" alt="step-2" class="img-fluid">
                            </div>
                            <ul>
                                <li>Read the instructions and click <span>Begin Verification. </span></li>
                                <li>Hold the face in frame and follow the instructions mentioned.
                                    (blinking, turning the head left or right, etc.) </li>
                                <h6 class="pt-3">Verification will be completed shortly.</h6>
                                <li>Tap <span>Close</span></li>
                                <h6 class="pt-3">The account will be sent for complete verification.</h6>
                                <!-- alert box -->
                                <div class=" alert-box alert alert-blue">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(52, 109, 219); --darkreader-inline-color: #69daff; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                    <p>Verification usually takes up to a few hours or 1-2 business days.
                                    </p>
                                </div>

                                <!-- alert box -->
                                <div class=" alert-box alert alert-blue">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(52, 109, 219); --darkreader-inline-color: #69daff; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                    <div>
                                        <p>After the verification of the account, you may opt for <span>Verified
                                                Plus</span>
                                            to increase the purchase and trading limits.
                                        </p>
                                        <p>This step is not mandatory for regular users.</p>
                                    </div>
                                </div>
                                <h6 class="title text-start pt-3" style="color: rgb(255, 255, 255); --darkreader-inline-color: #ffffff;" data-darkreader-inline-color="">ENABLE SECURITY FEATURES!</h6>
                                <!-- alert box -->
                                <div class=" alert-box alert alert-danger">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(240, 185, 11); --darkreader-inline-color: #ffff39; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>

                                    <div>
                                        <h5 class="title text-start">SECURITY!</h5>
                                        <p>Go to the ‘profile’ icon - tap ‘Security’ - enable additional security
                                            functions (Authenticator App/TEXT message/Email).</p>
                                    </div>
                                </div>
                            </ul>
                        </div>

                    </div>

                    <!-- Add Payment Methods -->
                    <div class="mt-4" border-radius: 10px; padding: 20px; --darkreader-inline-bgimage: initial; --darkreader-inline-bgcolor: #000000;" id="Add Payment Methods" data-darkreader-inline-bgimage="" data-darkreader-inline-bgcolor="">
                        <h4 class="title text-start"><b>4. Add Payment Methods</b></h4>

                        <ul>
                            <li>Go to <span>profile </span> icon (at the top left corner of the page).
                            </li>
                            <!-- Image -->
                            <div class="install-image pt-4 pb-3">
                                <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image12.webp" alt="step-2" class="img-fluid">
                            </div>
                            <li>Click <span>Payment Methods.</span></li>
                            <li>Press <span>P2P Payment Method(s).</span></li>
                            <li>Tap <span>Add a payment method.</span></li>
                            <!-- Image -->
                            <div class="install-image pt-4 pb-3">
                                <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image13.webp" alt="step-2" class="img-fluid">
                            </div>
                            <li>Choose from all the payment methods available:</li>
                            <ol>
                                <li>Paytm </li>
                                <li>IMPS </li>
                                <li>UPI </li>
                                <li>Bank Transfer</li>
                            </ol>
                            <li>Enter the details for each method accordingly and tap <span>Confirm</span></li>
                            <li>Press <span>All Payment Methods </span> to browse through different gateways available.
                                (For example - Google Pay (GPay) and Apple Pay are listed in ‘All Payment Methods.’)
                            </li>

                            <!-- alert box -->
                            <div class=" alert-box alert alert-blue">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(52, 109, 219); --darkreader-inline-color: #69daff; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                <div>
                                    <p>After adding at least one of the payment methods, the account becomes eligible
                                        for P2P transfers.
                                    </p>
                                    <p>Note that specific payment methods vary from seller to seller as per need.</p>
                                </div>
                            </div>

                        </ul>
                    </div>


                    <!-- Purchase of BNB/BUSD -->
                    <div class="mt-4" border-radius: 10px; padding: 20px; --darkreader-inline-bgimage: initial; --darkreader-inline-bgcolor: #000000;" id="Purchase of BNB/BUSD" data-darkreader-inline-bgimage="" data-darkreader-inline-bgcolor="">
                        <h4 class="title text-start"><b>5. Purchase of BNB/BUSD</b></h4>
                        <!-- Using Bank Card -->
                        <div>
                            <h6 class="title text-start pt-3" style="color: rgb(255, 255, 255); --darkreader-inline-color: #ffffff;" data-darkreader-inline-color="">1. Using Bank Card</h6>
                            <ul>
                                <li>Press the <span>exchange </span> icon</li>
                                <!-- Image -->
                                <div class="install-image pt-4 pb-3">
                                    <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image14.webp" alt="step-2" class="img-fluid">
                                </div>
                                <li>Tap <span>Deposit.</span></li>
                                <li>Search and choose the country's currency. </li>
                                <li>Select <span>Bank Card</span> (Visa/Master Card). <br>(You may opt for <span>Other
                                        Methods</span>, if suitable.) </li>
                                <li>Press <span>Continue.</span></li>
                                <!-- Image -->
                                <div class="install-image pt-4 pb-3">
                                    <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image15.webp" alt="step-2" class="img-fluid">
                                </div>
                                <li>Enter the <span>amount </span> (of fiat currency, for which you wish to purchase
                                    BNB/BUSD). </li>
                                <li>Tap <span>Add New Card. </span></li>
                                <li>Enter the required Card details:</li>
                                <ol>
                                    <li>Name </li>
                                    <li>Card number </li>
                                    <li>Expiry date </li>
                                    <li>CVV</li>
                                </ol>
                                <li>Press <span>Next </span> and <span>Continue</span></li>
                                <h6 class="pt-3">A Confirm Order will be placed.</h6>
                                <li>Put a <span>check </span> beside the T&amp;C and Privacy Policy. </li>
                                <li>Tap <span>Confirm.</span></li>
                            </ul>
                            <!-- alert box -->
                            <div class=" alert-box alert alert-blue">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(52, 109, 219); --darkreader-inline-color: #69daff; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                <p>After confirmation, the crypto amount will be credited to your spot wallet of
                                    BNB/BUSD in
                                    Binance exchange wallet.
                                </p>
                            </div>

                            <!-- alert box -->
                            <div class=" alert-box alert alert-danger">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(240, 185, 11); --darkreader-inline-color: #ffff39; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>

                                <div>
                                    <p><span>NOTE:</span>This method might ask for additional Security methods. </p>
                                    <p>Enable the email, phone number and authenticator feature from <span>Security
                                        </span>
                                        settings in profile (as per the steps mentioned above - SECURITY!).</p>
                                </div>
                            </div>
                        </div>

                        <!-- Using P2P (Peer-to-Peer Transfer)-->
                        <div>
                            <h6 class="title text-start pt-3" style="color: rgb(255, 255, 255); --darkreader-inline-color: #ffffff;" data-darkreader-inline-color="">2. Using P2P (Peer-to-Peer Transfer)
                            </h6>
                            <ul>
                                <li>Press the <span>exchange </span> icon</li>
                                <!-- Image -->
                                <div class="install-image pt-4 pb-3">
                                    <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image16.webp" alt="step-2" class="img-fluid">
                                </div>
                                <li>Tap <span>Buy.</span></li>
                                <li>Choose the cryptocurrency - <span>BNB</span> or <span>BUSD.</span></li>

                                <!-- Image -->
                                <div class="install-image pt-4 pb-3">
                                    <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image17.webp" alt="step-2" class="img-fluid">
                                </div>
                                <li>Enter the <span>amount </span> (of fiat money for which you wish to buy BNB/BUSD or
                                    the corresponding amount of BNB/BUSD directly). </li>
                                <li>Click <span> Buy BNB/BUSD.</span></li>
                                <li>Choose a <span>payment method</span> (added as per <a href="">step 1V</a>).</li>
                                <li>Press <span>Confirm.</span></li>
                                <h6 class="pt-3">Order will be created and matched with a seller shortly.</h6>
                                <!-- alert box -->
                                <div class=" alert-box alert alert-danger">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(240, 185, 11); --darkreader-inline-color: #ffff39; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                    <p>Check the details of the seller.</p>
                                </div>

                                <!-- Image -->
                                <div class="install-image pt-4 pb-3">
                                    <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image18.webp" alt="step-2" class="img-fluid">
                                </div>
                                <!-- alert box -->
                                <div class=" alert-box alert alert-blue">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(52, 109, 219); --darkreader-inline-color: #69daff; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                    <p><span>Chat </span> with the seller, if required for authenticity or conditions.
                                    </p>
                                </div>
                                <li>Press <span>Make Payment.</span></li>
                                <li>Details of the seller will appear as per the chosen payment method.
                                    (UPI, IMPS or Bank Transfer details of the seller).</li>
                                <ol>
                                    <li>Keep the Binance screen running in the background. </li>
                                    <li>Switch to your respective payment platform (UPI payment app or Bank app).</li>
                                    <li>Pay the designated amount at the details of seller shown in Binance app. </li>
                                    <li>After successful payment, revert to Binance.</li>
                                </ol>
                                <li>Press <span>Transferred, notify seller.</span></li>
                                <!-- Image -->
                                <div class="install-image pt-4 pb-3">
                                    <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image19.webp" alt="step-2" class="img-fluid">
                                </div>
                                <li>Approve the ‘Payment Confirmation’ by pressing <span>I Have Transferred.</span></li>
                                <!-- alert box -->
                                <div class=" alert-box alert alert-danger">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(240, 185, 11); --darkreader-inline-color: #ffff39; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                    <div>
                                        <p>This step should be done only after a confirmation that the payment has been
                                            done.</p>
                                        <span>Failing to do so can result in discrepencies and accountability.</span>
                                    </div>
                                </div>
                                <li>Put a <span>check </span> against the confirmation.</li>
                                <li>Press <span>Confirm payment.</span></li>
                                <!-- alert box -->
                                <div class=" alert-box alert alert-blue">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(52, 109, 219); --darkreader-inline-color: #69daff; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                    <div>
                                        <p>After confirmation from the seller, the crypto amount will be sent to your
                                            spot wallet of BNB/BUSD in Binance exchange wallet.
                                        </p>
                                        <p>You will be notified of the crypto credit through App notifications.</p>
                                    </div>
                                </div>
                                <!-- Image -->
                                <div class="install-image pt-4 pb-3">
                                    <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image20.webp" alt="step-2" class="img-fluid">
                                </div>
                                <!-- alert box -->
                                <div class=" alert-box alert alert-danger">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(240, 185, 11); --darkreader-inline-color: #ffff39; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                    <p><span>NOTE:</span> Release of crypto can take time, if not credited within the
                                        displayed time limit, request for an <span>Appeal.</span></p>
                                </div>
                                <!-- alert box -->
                                <div class=" alert-box alert alert-blue">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(52, 109, 219); --darkreader-inline-color: #69daff; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                    <p><span>Congratulations!</span> The purchase of cryptocurrency has been done
                                        successfully.</p>
                                </div>

                            </ul>
                        </div>
                    </div>

                    <!-- Withdraw BNB/BUSD to personal wallet -->
                    <div class="mt-4" border-radius: 10px; padding: 20px; --darkreader-inline-bgimage: initial; --darkreader-inline-bgcolor: #000000;" id="Withdraw BNB/BUSD to personal wallet" data-darkreader-inline-bgimage="" data-darkreader-inline-bgcolor="">
                        <h4 class="title text-start"><b>6. Withdraw BNB/BUSD to personal wallet</b></h4>
                        <ul>
                            <li>Go to <span>wallet</span> icon (at bottom right of the page).</li>
                            <!-- Image -->
                            <div class="install-image pt-4 pb-3">
                                <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image21.webp" alt="step-2" class="img-fluid">
                            </div>
                            <li>Click on <span>BNB/BUSD.</span></li>
                            <li>Press <span>Withdrawal.</span></li>
                            <!-- Image -->
                            <div class="install-image pt-4 pb-3">
                                <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image22.webp" alt="step-2" class="img-fluid">
                            </div>
                            <li>Enter the <span> receiving address</span> of your personal wallet.</li>
                            <!-- alert box -->
                            <div class=" alert-box alert alert-danger">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(240, 185, 11); --darkreader-inline-color: #ffff39; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                <p>Make sure it is a <span>BSC BEP-20</span> wallet address starting with- <span>
                                        '0x...'</span></p>
                                <p><span>Once a transaction has been sent to the wrong wallet address, it cannot be
                                        retrieved.</span></p>
                            </div>
                            <li>Select <span>BNB Smart Chain (BEP-20) Network</span> (if not detected already).</li>
                            <li>Enter the <span>Amount </span> (within the decided limits).</li>
                            <li>Tap on <span>Withdrawal.</span></li>
                            <li>Confirm the order by pressing <span>Confirm </span> button</li>
                            <!-- alert box -->
                            <div class=" alert-box alert alert-blue">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(52, 109, 219); --darkreader-inline-color: #69daff; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                <div>
                                    <p>Pass the 'Risk Warning' by clicking <span>Verify Now. </span>
                                    </p>
                                    <p>This step may or may not be asked. If asked, thoroughly read the security
                                        questions and answer accordingly.</p>
                                </div>
                            </div>
                            <!-- Image -->
                            <div class="install-image pt-4 pb-3">
                                <img src="https://p2p.coinxfiat.com/assets/themes/peerToPeer/images/wallet-setup/binance-image23.webp" alt="step-2" class="img-fluid">
                            </div>
                            <h6>Complete the <span>Verification.</span></h6>
                            <li>Tap <span>Send Code.</span></li>
                            <ol>
                                <li>Enter the code sent to your registered <span>phone number</span> (if added as per
                                    Security steps).</li>
                                <li>Enter the code sent to your registered <span>email address</span> (if added as per
                                    Security steps). </li>
                                <li>Enter the verification code from <span> Google Authenticator App</span> (if added as
                                    per Security steps).</li>
                            </ol>
                            <li>Press <span>Submit.</span></li>
                            <!-- alert box -->
                            <div class=" alert-box alert alert-blue">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-circle icon" style="color: rgb(52, 109, 219); --darkreader-inline-color: #69daff; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                <p>The order will be processed shortly and your personal wallet will be funded.</p>
                            </div>
                            <!-- alert box -->
                            <div class=" alert-box alert alert-success">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-check-circle icon" style="color: green; --darkreader-inline-color: #abffab; --darkreader-inline-stroke: currentColor;" data-darkreader-inline-color="" data-darkreader-inline-stroke=""><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                <p><span>Congratulations!</span> The wallet has been funded successfully.</p>
                            </div>
                        </ul>


                    </div>
                </div>
            </div>
            ''';

String privatePolicyHTML = '''
<section class="mt-5" id="policy">
        <div class="container">
            <div class="policy wow fadeInUp" data-wow-duration="1s" data-wow-delay="0.35s">
                <p>Welcome to our Peer-to-Peer Crypto Trading Platform. This Privacy Policy outlines how we collect, use, disclose, and protect your personal information. By accessing or using our services, you consent to the practices described in this Privacy Policy.</p><p>1. *Information We Collect:*</p><p>&nbsp; &nbsp;- Personal Information: We collect user-provided information during registration and transactions, including name, email, and wallet addresses.</p><p>&nbsp; &nbsp;- Transaction Data: Details of your crypto transactions, including trading history, are recorded on our platform.</p><p>2. *How We Use Your Information:*</p><p>&nbsp; &nbsp;- Facilitate Transactions: Your information is used to process and facilitate crypto transactions between users.</p><p>&nbsp; &nbsp;- Communication: We may contact you regarding transactions, updates, and support.</p><p>&nbsp; &nbsp;- Improve Services: Your data helps us enhance our platform, services, and user experience.</p><p>3. *Data Security:*</p><p>&nbsp; &nbsp;- We implement industry-standard security measures to protect your data; however, no system is entirely secure.</p><p>&nbsp; &nbsp;- You are responsible for maintaining the confidentiality of your account credentials.</p><p>4. *Sharing Your Information:*</p><p>&nbsp; &nbsp;- Transaction Details: Your trading history, including wallet addresses, may be visible to other users involved in transactions.</p><p>&nbsp; &nbsp;- Legal Requirements: We may share information to comply with legal obligations or protect our rights.</p><p>5. *Your Choices:*</p><p>&nbsp; &nbsp;- You can edit your account information and communication preferences.</p><p>&nbsp; &nbsp;- You have the right to access, update, or delete your personal data.</p><p>6. *Cookies and Tracking:*</p><p>&nbsp; &nbsp;- We use cookies and similar technologies to enhance your experience and analyze user behavior.</p><p>7. *Third-Party Links:*</p><p>&nbsp; &nbsp;- Our platform may contain links to third-party websites. We are not responsible for their privacy practices.</p><p>8. *Children's Privacy:*</p><p>&nbsp; &nbsp;- Our services are not intended for individuals under legal age. We do not knowingly collect data from minors.</p><p>9. *Changes to Privacy Policy:*</p><p>&nbsp; &nbsp;- We may update this Privacy Policy. Changes will be posted on our website and will become effective upon posting.</p><p>10. *Contact Us:*</p><p>&nbsp; &nbsp;- For inquiries or concerns regarding your personal data, please contact our Privacy Officer at [email address].</p><p>By using our Peer-to-Peer Crypto Trading Platform, you consent to the collection and use of your personal information as outlined in this Privacy Policy. If you do not agree, please refrain from using our services.</p>            </div>
        </div>
    </section>
''';

String termsAndConditionsHTML = '''


        <!-- POLICY -->
    <section class="mt-5" id="policy">
        <div class="container">
            <div class="policy wow fadeInUp" data-wow-duration="1s" data-wow-delay="0.35s">
                <p><span>Welcome to our Peer-to-Peer Crypto Trading Platform. By accessing and using our services, you agree to comply with these Terms &amp; Conditions. Please read this document carefully before proceeding.</span><br></p><p>1. *User Agreement:*</p><p>&nbsp; &nbsp;- You must be of legal age to use our platform in your jurisdiction.</p><p>&nbsp; &nbsp;- You are solely responsible for the accuracy of your personal information provided during registration.</p><p>2. *Transactions:*</p><p>&nbsp; &nbsp;- Transactions are conducted directly between users. We do not hold custody of funds.</p><p>&nbsp; &nbsp;- Users must verify the accuracy of transaction details before confirming a trade.</p><p>3. *Wallet Integration:*</p><p>&nbsp; &nbsp;- By connecting your wallet to our platform, you authorize the platform to initiate transactions on your behalf.</p><p>&nbsp; &nbsp;- Ensure the security of your wallet and private keys. We are not liable for unauthorized access.</p><p>4. *Fees and Charges:*</p><p>&nbsp; &nbsp;- Our platform operates with minimal fees, clearly indicated during the transaction process.</p><p><br></p><p>5. *Privacy:*</p><p>&nbsp; &nbsp;- We respect your privacy and handle personal data in accordance with our Privacy Policy.</p><p>6. *Prohibited Activities:*</p><p>&nbsp; &nbsp;- Users must not engage in illegal, fraudulent, or harmful activities on the platform.</p><p>&nbsp; &nbsp;- Manipulation of transaction data, phishing, or any form of hacking is strictly prohibited.</p><p>7. *Dispute Resolution:*</p><p>&nbsp; &nbsp;- Users are encouraged to resolve disputes amicably. We do not mediate or assume liability for disputes.</p><p>8. *Security:*</p><p>&nbsp; &nbsp;- We employ industry-standard security measures. However, we do not guarantee the platform's absolute security.</p><p>9. *Disclaimer:*</p><p>&nbsp; &nbsp;- Cryptocurrency trading involves risks. Users are responsible for their own decisions and investments.</p><p>10. *Modification of Terms:*</p><p>&nbsp; &nbsp;- We reserve the right to modify these Terms &amp; Conditions at any time. Changes will be notified to users.</p><p>11. *Termination:*</p><p>&nbsp; &nbsp;- We reserve the right to suspend or terminate user accounts for violation of terms or any inappropriate behavior.</p><p>12. *Governing Law:*</p><p>&nbsp; &nbsp;- These Terms &amp; Conditions are governed by the laws of [Jurisdiction]. Any disputes shall be resolved in the appropriate courts of [Jurisdiction].</p><p>By accessing and using our platform, you acknowledge that you have read, understood, and agreed to these Terms &amp; Conditions. If you do not agree, please refrain from using our services. For any inquiries or concerns, please contact our support team.</p><p><br></p>            </div>
        </div>
    </section>
    <!-- /POLICY -->

''';
